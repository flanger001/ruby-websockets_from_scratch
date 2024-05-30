function initWs(cb) {
    const ws = new WebSocket(`ws://${window.locals["LOCAL_IP"]}:9292/ws`)
    ws.onerror = (e) => console.log(e)
    ws.onclose = (e) => console.log(e)
    ws.onopen = (e) => console.log(e)
    ws.onmessage = (e) => {
        console.log(e.data)
        cb(e.data)
    }
    return ws
}

function formatDate() {
    const date = new Date()
    return `${date.toLocaleDateString("en-CA")} ${date.toLocaleTimeString("en-GB")}`
}

function clearAndFocusField(field) {
    field.value = ""
    field.focus()
}

function ready() {
    const messageLog = document.getElementById("messages")
    const messageInput = document.getElementById("message")
    const sendMessageButton = document.getElementById("send-message")
    const closeConnectionButton = document.getElementById("close-connection")
    const reopenConnectionButton = document.getElementById("reopen-connection")

    let ws = initWs(logMessage)
    clearAndFocusField(messageInput)

    document.addEventListener("keydown", event => {
        if (event.key === "Enter") {
            sendMessageButton.click()
        }
    })


    sendMessageButton.addEventListener("click", (event) => {
        event.preventDefault()
        event.stopPropagation()
        ws.send(messageInput.value)
        clearAndFocusField(messageInput)
    })

    function logMessage(message) {
        const el = document.createElement("p")
        el.innerText = `${formatDate()}: ${message}`
        messageLog.appendChild(el)
    }

    closeConnectionButton.addEventListener("click", (event) => {
        event.preventDefault()
        event.stopPropagation()
        console.log("Closing connection")
        ws.close(1000, "It's fine. We said it's fine.")
    })

    reopenConnectionButton.addEventListener("click", (event) => {
        event.preventDefault()
        event.stopPropagation()
        console.log("Reopening connection")
        ws = initWs(logMessage)
    })
}

document.addEventListener("DOMContentLoaded", ready)
