// server.js

const express = require('express');
const http = require('http');
const socketIo = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

// Serve static files from the current directory
app.use(express.static(__dirname));

// Keep track of connected users
const users = {};

// Handle WebSocket connections
io.on('connection', (socket) => {
    console.log('A user connected');

    // Handle user authentication and setting username
    socket.on('setUsername', (username) => {
        if (!username || users[username]) {
            socket.emit('userExists', `${username} is already taken.`);
        } else {
            users[username] = socket.id;
            socket.username = username;
            io.emit('userJoined', username);
            io.emit('userList', Object.keys(users));
        }
    });

    
    // Handle private messages
socket.on('private message', ({ recipient, message }) => {
    const recipientSocketId = users[recipient];
    if (recipientSocketId) {
        io.to(recipientSocketId).emit('open conversation', socket.username);
        io.to(recipientSocketId).emit('private message', { sender: socket.username, message }); // Include sender's username
    } else {
        socket.emit('errorMessage', `User ${recipient} is not connected.`);
    }
});


    // Handle disconnection
    socket.on('disconnect', () => {
        if (socket.username) {
            delete users[socket.username];
            io.emit('userLeft', socket.username);
            io.emit('userList', Object.keys(users));
        }
        console.log('A user disconnected');
    });
});

// Start the server
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
});
