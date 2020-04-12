import {Socket} from "phoenix"

var playerName = null;

let playerColor = new Map()
playerColor.set("player1","blue")
playerColor.set("player2","green")
let player1Color = "blue"
let player2Color = "green"
let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()
let channel = socket.channel("game:nine-men-morris", {})

channel.join()
    .receive("ok", resp => {

        console.log("Joined successfully"

            , resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

export default socket

socket.onMessage(function(event,payload,ref) {
    console.log(event.event)

    if(event.event == "update_board_position" && event.payload.playerName != playerName) {
        let pos = event.payload.position
        Array.from(document.querySelectorAll('circle')).forEach(function(circle) {
            if(circle.getAttribute("class") == pos){
                circle.setAttribute("fill", playerColor.get(event.payload.playerName))
            }
        })
    }

})

let buttons = Array.from(document.querySelectorAll('button'))
buttons.forEach(function (button) {
    button.addEventListener("click",function () {

        let player = button.innerText
        if(player == "Player1" && playerName == null){
            playerName = "player1"
            console.log("Player1")
            button.style.background=player1Color
        } else if(player == "Player2" && playerName == null) {
            playerName = "player2"
            console.log("Player2")
            button.style.background=player2Color
        } else {
            console.log("Unknown state")
            alert("already selected "+playerName)
        }

    })
})

let circles = Array.from(document.querySelectorAll('circle'))
circles.forEach(function(circle) {

    circle.addEventListener("click", function () {
        let color = circle.getAttribute("fill")
        let position = circle.getAttribute("class")
        let message = {"action" : "add","position" : position,"playerName" : playerName}
        channel.push("add",message,5000).receive("ok",msg => {
            if(playerName != null && playerName == "player1") {
                circle.setAttribute("fill", playerColor.get("player1"))
            } else if(playerName != null && playerName == "player2") {
                circle.setAttribute("fill", playerColor.get("player2"))
            } else {
                alert("Unknown player "+playerName)
            }
        }).receive("error", msg =>{
            alert(msg["reason"])
        })
    },false);
})

