import {Socket} from "phoenix"

let playerName = "player1"
let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()
let channel = socket.channel("game:nine-men-morris", {})

channel.join()
    .receive("ok", resp => {

        console.log("Joined successfully"

            , resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

export default socket



let circles = Array.from(document.querySelectorAll('circle'))
circles.forEach(function(circle) {

    circle.addEventListener("click", function () {
        let color = circle.getAttribute("fill")
        let position = circle.getAttribute("class")
        let message = {"action" : "add","position" : position,"playerName" : playerName}
        channel.push("add",message,5000).receive("ok",msg => {
            circle.setAttribute("fill","blue")
        }).receive("error", msg =>{
            alert(msg["reason"])
        })
    },false);
})

