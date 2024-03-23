// script.js

const socket = io();
const chatMessages = document.getElementById('chat-messages');
const userList = document.getElementById('user-list');
const authenticationContainer = document.getElementById('authentication-container');
const chatContainer = document.getElementById('chat-container');

const usernameInput = document.getElementById('username-input');
const setUsernameButton = document.getElementById('set-username-button');
const messageInput = document.getElementById('message-input');
const sendButton = document.getElementById('send-button');

let selectedUser = null;
let currentUser = null; // Store the current user's username
let messages = []; // Store all the messages

// Event listener for setting the username
setUsernameButton.addEventListener('click', () => {
    const username = usernameInput.value.trim();
    if (username !== '') {
        socket.emit('setUsername', username);
        chatContainer.style.display = 'block';
        authenticationContainer.style.display = 'none';
        currentUser = username; // Set the current user's username
    }
});

// Event listener for sending messages
sendButton.addEventListener('click', () => {
    const message = messageInput.value.trim();
    if (message !== '') {
        if (selectedUser) {
            // Display the sent message immediately
            displaySentMessage(currentUser, selectedUser, message);
            // Emit the message to the server
            socket.emit('private message', { recipient: selectedUser, message });
            // Add the message to the local messages array
            messages.push({ sender: currentUser, recipient: selectedUser, content: message });
            // Clear the message input
            messageInput.value = '';
        } else {
            alert('Please select a user to send a message.');
        }
    }
});

// Event listener for selecting a user from the list
userList.addEventListener('click', (event) => {
    const target = event.target;
    
    if (target && target.classList.contains('user')) {
        selectedUser = target.innerText;
        chatMessages.style.backgroundColor = 'rgb(50, 50, 189)';
        displayConversation(selectedUser);
    }
});

// Function to display a sent message immediately
function displaySentMessage(sender, recipient, message) {
    const messageElement = document.createElement('div');
    messageElement.innerHTML = `<strong>[You to ${recipient}]:</strong> ${message}`;
    chatMessages.appendChild(messageElement);
}

// Function to display conversation with a selected user or create a new one if it doesn't exist
function displayConversation(username) {
    // Clear chat messages
    chatMessages.innerHTML = '';

    // Display conversation header
    const conversationHeader = document.createElement('h3');
    conversationHeader.textContent = `Conversation with ${username}`;
    chatMessages.appendChild(conversationHeader);

    // Filter messages relevant to the selected user and display them
    const relevantMessages = messages.filter(message =>
        (message.sender === currentUser && message.recipient === username) ||
        (message.sender === username && message.recipient === currentUser)
    );

    relevantMessages.forEach(message => {
        const messageElement = document.createElement('div');
        messageElement.innerHTML = `<strong>[${message.sender}]:</strong> ${message.content}`;
        chatMessages.appendChild(messageElement);
    });

    // Display chat container
    chatContainer.style.display = 'block';
    authenticationContainer.style.display = 'none';
}

// Socket event listeners

socket.on('userExists', (message) => {
    alert(message);
});

socket.on('userList', (users) => {
    userList.innerHTML = '<p >please click on the name of user that you want to contact wmb3da ab3tlou msg </p><p>Users li rahom Online : (li blekhder c vous ! )</p>';
    
    users.forEach(user => {
        const userElement = document.createElement('div');
        userElement.innerText = user;
        userElement.classList.add('user');
        if (user === currentUser) {
            userElement.classList.add('current-user'); // Apply special style to current user's username
        }
        userList.appendChild(userElement);
    });
});

socket.on('userJoined', (username) => {
    const userElement = document.createElement('div');
    userElement.innerText = username;
    userElement.classList.add('user');
    userList.appendChild(userElement);
});

socket.on('userLeft', (username) => {
    const userElements = document.querySelectorAll('.user');
    userElements.forEach(element => {
        if (element.innerText === username) {
            element.remove();
        }
    });
    if (selectedUser === username) {
        selectedUser = null;
        chatMessages.innerHTML = '';
    }
});

// Socket event listener for receiving private messages
socket.on('private message', ({ sender, message }) => {
    // Add the received message to the local messages array
    messages.push({ sender, recipient: currentUser, content: message });
    // Display the message if it's from the selected user
    if (selectedUser === sender) {
        const messageElement = document.createElement('div');
        messageElement.innerHTML = `<strong>[${sender}]:</strong> ${message}`;
        chatMessages.appendChild(messageElement);
    }
});

socket.on('open conversation', (sender) => {
    if (!selectedUser || selectedUser !== sender) {
        selectedUser = sender;
        chatMessages.style.backgroundColor = 'rgb(50, 50, 189)';
        displayConversation(selectedUser);
    }
});

socket.on('errorMessage', (message) => {
    alert(message);
});
