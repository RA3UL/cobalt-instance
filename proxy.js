// Proxy Express -> Cobalt on internal port 9000
// This lets us bind Railway's $PORT while Cobalt keeps using 9000 internally.
import express from "express";
import { createProxyMiddleware } from "http-proxy-middleware";

const app = express();
const PORT = process.env.PORT || 8080;
const COBALT = process.env.COBALT_URL || "http://localhost:9000";

app.use("/", createProxyMiddleware({
    target: COBALT,
    changeOrigin: true,
    ws: true,
    on: {
        error: (err, req, res) => {
            console.error("Proxy error:", err.message);
            if (res.writeHead) {
                res.writeHead(502, { "Content-Type": "application/json" });
                res.end(JSON.stringify({ error: "Cobalt upstream unreachable" }));
            }
        }
    }
}));

app.listen(PORT, () => {
    console.log(`Cobalt proxy listening on :${PORT} -> ${COBALT}`);
});
