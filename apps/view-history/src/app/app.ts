// import express from "express"
// import bodyParser from "body-parser"

// const app = express()

// app.use(bodyParser.json())

// app.get("/history", async (req, res) => {
//     if(typeof req.query.skip !== "string" || typeof req.query.limit !== "string"){
//         return
//     }
//     const skip = parseInt(req.query.skip)
//     const limit = parseInt(req.query.limit)
//     const document = await videosCollection.find()
//         .skip(skip)
//         .limit(limit)
//         .toArray()
//     res.json({history: document})
// })

// export default app
