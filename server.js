const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const { Pool } = require('pg');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

const pool = new Pool({
    host: 'dpg-cnu9h5a0si5c73ds58mg-a.oregon-postgres.render.com',
    user: 'keddour',
    password: 'ajHdWafoMvmbFB8erfBgqkdjafOUxdzU',
    database: 'achraf_16qa',
    port: 5432, // PostgreSQL port
    ssl: {
        rejectUnauthorized: false // For Render's PostgreSQL SSL
    }
});


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
    socket.on('private message', async ({ recipient, message }) => {
        const recipientSocketId = users[recipient];
        if (recipientSocketId) {
            io.to(recipientSocketId).emit('open conversation', socket.username);
            io.to(recipientSocketId).emit('private message', { sender: socket.username, message }); // Include sender's username

            try {
                // Store the message in the database
                const client = await pool.connect();
                await client.query('INSERT INTO messages (sender, receiver, message) VALUES ($1, $2, $3)', [socket.username, recipient, message]);
                client.release();
            } catch (error) {
                console.error('Error storing message in the database:', error);
            }
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
