import {Socket} from "phoenix"

var playerName = null
var phase= 1
var canDelete=false
var selectedPosition = null
var selectedCircle = null
var remaining = 9
var isMill = false

const playerColor = new Map()
playerColor.set("player1","blue")
playerColor.set("player2","green")
playerColor.set("selected","yellow")
playerColor.set("empty","black")

let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()
let channel = socket.channel("game:nine-men-morris", {})

channel.join()
    .receive("ok", resp => {console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

export default socket

function log(message){
    document.getElementsByName("logterminal")[0].value += ("\n"+message)
}

function renderBoard(board) {
    console.log(board)
    Array.from(document.querySelectorAll('circle')).forEach(function(circle) {
      let pos = circle.getAttribute("pos")
      let player = board[pos]
      if(player == 0){
          circle.setAttribute("fill", playerColor.get("empty"))
      } else {
          circle.setAttribute("fill", playerColor.get(player))
      }

    })
}

socket.onMessage(function(event,payload,ref) {

    if(event.event == "update_board_position_add" && event.payload.playerName != playerName) {
       renderBoard(event.payload.board)
       console.log(event.payload.log)
       log(event.payload.log)
    } else if(event.event == "update_board_position_move" && event.payload.playerName != playerName) {
       renderBoard(event.payload.board)
       console.log(event.payload.log)
       log(event.payload.log)
    } else if(event.event == "update_board_position_remove" && event.payload.playerName != playerName) {
       renderBoard(event.payload.board)
       console.log(event.payload.log)
       log(event.payload.log)
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
        if(isMill){
            let message = {"action" : "remove","position" : position,"playerName" : playerName}
            channel.push("remove",message,5000).receive("ok",msg => {
                renderBoard(msg.board)
                isMill = false
            }).receive("error", msg =>{
                alert(msg["reason"])
            })
        } else if(phase == 1  && remaining > 0){
            let message = {"action" : "add","position" : position,"playerName" : playerName}
            channel.push("add",message,5000).receive("ok",msg => {
                remaining = msg.remainingPieces
                console.log("remaining  " + remaining)
                circle.setAttribute("fill", playerColor.get(playerName))
                if(msg.mill != null){
                    isMill = true
                }

                if(remaining == 0) {
                    phase = 2
                }
            }).receive("error", msg =>{
                alert(msg["reason"])
            })


        } else if(phase == 2 && remaining == 0 && selectedPosition == null){
            selectedPosition = position
            circle.setAttribute("fill", playerColor.get("selected"))
            selectedCircle = circle

        } else if(phase == 2 && remaining == 0 && selectedPosition != null) {
            let message = {"action" : "move","fromPosition" : selectedPosition,"toPosition" : position ,"playerName" : playerName}
            channel.push("move",message,5000).receive("ok",msg => {
                if(playerName != null && playerName == "player1") {
                    circle.setAttribute("fill", playerColor.get("player1"))
                    selectedCircle.setAttribute("fill",playerColor.get("empty"))
                } else if(playerName != null && playerName == "player2") {
                    circle.setAttribute("fill", playerColor.get("player2"))
                    selectedCircle.setAttribute("fill",playerColor.get("empty"))
                } else {
                    selectedCircle.setAttribute("fill",playerColor.get(playerName))
                    alert("Unknown error "+playerName)
                }
            }).receive("error", msg =>{
                selectedCircle.setAttribute("fill",playerColor.get(playerName))
                alert(msg["reason"])
            })
            selectedPosition = null
        }
    },false);
})

