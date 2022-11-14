import request from "supertest"
import app from "../app/app"

describe("test", () => {
    it("Video from aws-storage service (GET /video)", async () => {
        const res = await request(app).get("/video")
        expect(res.statusCode).toBe(200)
        expect(res.headers["content-type"]).toBe("video/mp4")
    })

})
