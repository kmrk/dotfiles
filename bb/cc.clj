#!/usr/bin/env bb
;; cc —— 多账号启动 Claude Code。每个账号一个配置目录（CLAUDE_CONFIG_DIR），凭据各自独立。
;;
;;   cc            列出已有账号，选编号启动；输入新名字则新建
;;   cc <name>     直接用该账号启动（不存在就新建，首次启动会让你登录）
;;   cc <name> -c  名字后面的参数原样传给 claude
;;
;; 账号目录：default → ~/.claude（不设 CLAUDE_CONFIG_DIR，沿用 ~/.claude.json）；其它 → ~/.claude-<name>
;; 新建时把 SHARED 里的全局规则 / 设置 / 技能从 ~/.claude 软链接过去，两边保持一致。
;; .credentials.json 绝不能链接，否则两个名字其实是同一个账号。

(require '[babashka.fs :as fs]
         '[babashka.process :as p]
         '[cheshire.core :as json]
         '[clojure.string :as str])

(def home (str (fs/home)))
(def base-dir (str home "/.claude"))

;; 新建账号时从 ~/.claude 软链接过去的东西（不存在的跳过）。
;; projects 里是会话记录和项目记忆，默认不共享；想让两个账号共用记忆就把 "projects" 加进来。
(def SHARED ["CLAUDE.md" "RTK.md" "KEP.md" "settings.json" "skills" "hooks" "plugins" "agents" "commands"])

(defn profile-dir [name]
  (if (= name "default") base-dir (str home "/.claude-" name)))

(defn global-config [name]
  ;; 不设 CLAUDE_CONFIG_DIR 时全局配置在 ~/.claude.json，设了就在目录里
  (if (= name "default") (str home "/.claude.json") (str (profile-dir name) "/.claude.json")))

(defn email [name]
  (let [f (global-config name)]
    (when (fs/exists? f)
      (try (get-in (json/parse-string (slurp f)) ["oauthAccount" "emailAddress"])
           (catch Exception _ nil)))))

;; 只认本脚本建的目录（带标记文件）：~/.claude-code-router 这类别的工具目录名字也是 .claude-* 开头
(def MARKER ".cc-profile")

(defn profiles []
  (let [others (->> (fs/list-dir home)
                    (filter #(and (str/starts-with? (str (fs/file-name %)) ".claude-")
                                  (fs/exists? (fs/path % MARKER))))
                    (map #(subs (str (fs/file-name %)) (count ".claude-")))
                    sort)]
    (cons "default" others)))

(defn valid-name? [s] (boolean (re-matches #"[A-Za-z0-9_-]+" s)))

(defn ensure-profile! [name]
  (let [dir (profile-dir name)]
    (when-not (fs/exists? dir)
      (fs/create-dirs dir)
      (spit (str dir "/" MARKER) "")
      (println (str "新建账号目录 " dir))
      (doseq [item SHARED
              :let [src (str base-dir "/" item)
                    dst (str dir "/" item)]
              :when (and (fs/exists? src) (not (fs/exists? dst {:nofollow-links true})))]
        (fs/create-sym-link dst src)
        (println (str "  链接 " item)))
      (println "首次启动需要登录：在 Claude Code 里按提示登录第二个账号。"))
    dir))

(defn choose []
  (let [ps (vec (profiles))]
    (println "选择账号：")
    (doseq [[i n] (map-indexed vector ps)]
      (println (format "  %d) %-12s %s" (inc i) n
                       (or (email n)
                           (if (fs/exists? (str (profile-dir n) "/.credentials.json")) "已登录" "未登录")))))
    (print "输入编号（回车 = 1），或输入新名字新建：")
    (flush)
    (let [in (str/trim (or (read-line) ""))]
      (cond
        (str/blank? in) (first ps)
        (re-matches #"\d+" in) (let [i (dec (parse-long in))]
                                 (or (get ps i) (do (println "没有这个编号") (System/exit 1))))
        (valid-name? in) in
        :else (do (println "名字只能用字母、数字、- 和 _") (System/exit 1))))))

(defn launch! [name args]
  (let [dir (ensure-profile! name)
        env (if (= name "default") {} {"CLAUDE_CONFIG_DIR" dir})]
    (println (str "→ claude [" name (when-let [e (email name)] (str " · " e)) "]"))
    ;; exec 替换当前进程，claude 直接接管终端
    (apply p/exec {:extra-env env} "claude" args)))

(let [[a & more] *command-line-args*]
  (cond
    (#{"-h" "--help" "help"} a) (println "用法：cc [name] [claude 参数...]")
    (or (nil? a) (str/starts-with? a "-")) (launch! (choose) (vec *command-line-args*))
    (valid-name? a) (launch! a (vec more))
    :else (do (println "名字只能用字母、数字、- 和 _") (System/exit 1))))
