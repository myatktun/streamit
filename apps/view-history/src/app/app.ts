import express from "express"
import bodyParser from "body-parser"
import { connectDB, startMessageQueue } from "./helpers"

const app = express()

app.use(bodyParser.json())

const db = connectDB()
startMessageQueue(db)

app.get("/history", async (req, res) => {
    const skip =
        typeof req.query.skip !== "string" ? 0 : parseInt(req.query.skip)
    const limit =
        typeof req.query.limit !== "string" ? 0 : parseInt(req.query.limit)
    const videosCollection = (await db).collection("videos")
    if (videosCollection instanceof Error) {
        console.log(videosCollection)
        res.status(400)
        return
    }
    const document = await videosCollection
        .find()
        .skip(skip)
        .limit(limit)
        .toArray()
    res.json({ history: document })
})

export default app
