import app from "./app/app"

if (!process.env.PORT) {
    throw new Error("Environment variable PORT not specified")
}

const PORT = process.env.PORT

const main = async () => {
    try {
        app.listen(PORT, () => {
            console.log(`View History service on port ${PORT}`)
        })
    } catch (error) {
        console.error(error)
    }
}

main()
