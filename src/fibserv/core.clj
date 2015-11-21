(ns fibserv.core
  (:require [ring.adapter.jetty :as jetty]
            [ring.middleware.json :refer [wrap-json-response]]
            [ring.middleware.params :refer [wrap-params]])
  (:use fibserv.core)
  (:gen-class))

; https://en.wikibooks.org/wiki/Clojure_Programming/Examples/Lazy_Fibonacci
(def fib-seq
  ((fn rfib [a b]
     (lazy-seq (cons a (rfib b (+ a b)))))
    (bigint 0) (bigint 1)))

(defn handler [{params :params}]
  (let [fib-index (Long/parseLong (get params "i"))
        fib-value (nth fib-seq fib-index)]
    {:status  200
     :headers {"Content-Type" "application/json"}
     :body    {fib-index fib-value}}))

(defn -main []
  (jetty/run-jetty (->> handler wrap-params wrap-json-response) {:port 3000}))