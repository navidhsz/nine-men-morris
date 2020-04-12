import {Socket} from "phoenix"

var playerName = null
var phase= 1
var canDelete=false
var selectedPosition = null
var remaining = 9

const playerColor = new Map()
playerColor.set("player1","blue")
playerColor.set("player2","green")
playerColor.set("selected","yellow")

let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()
let channel = socket.channel("game:nine-men-morris", {})

channel.join()
    .receive("ok", resp => {console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

export default socket

socket.onMessage(function(event,payload,ref) {
    console.log(event.event)

    if(event.event == "update_board_position_add" && event.payload.playerName != playerName) {
        let pos = event.payload.position
        Array.from(document.querySelectorAll('circle')).forEach(function(circle) {
            if(circle.getAttribute("pos") == pos){
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
            button.style.background=playerColor.get("player1")
        } else if(player == "Player2" && playerName == null) {
            playerName = "player2"
            console.log("Player2")
            button.style.background=playerColor.get("player2")
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
        let position = circle.getAttribute("pos")

        if(phase == 1  && remaining > 0){
            let message = {"action" : "add","position" : position,"playerName" : playerName}
            channel.push("add",message,5000).receive("ok",msg => {
                remaining = msg.remainingPieces
                console.log("remaining  " + remaining)
                if(playerName != null && playerName == "player1") {
                    circle.setAttribute("fill", playerColor.get("player1"))
                } else if(playerName != null && playerName == "player2") {
                    circle.setAttribute("fill", playerColor.get("player2"))
                } else {
                    alert("Unknown error "+playerName)
                }

                if(remaining == 0) {
                    phase = 2
                }
            }).receive("error", msg =>{
                alert(msg["reason"])
            })


        } else if(phase == 2 && remaining == 0){
            let message = {"action" : "move","position" : position,"playerName" : playerName}
            channel.push("move",message,5000).receive("ok",msg => {
                if(playerName != null && playerName == "player1") {
                    circle.setAttribute("fill", playerColor.get("player1"))
                } else if(playerName != null && playerName == "player2") {
                    circle.setAttribute("fill", playerColor.get("player2"))
                } else {
                    alert("Unknown error "+playerName)
                }
            }).receive("error", msg =>{
                alert(msg["reason"])
            })

        }
    },false);
})

