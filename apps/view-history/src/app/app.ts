import express from "express"

const app = express()

app.get("/", (req, res) => {
    res.send("hello from view history service")
})

export default app
