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

    if (target && target.classList.contains('list-group-item')) {
        selectedUser = target.innerText.trim();
        displayConversation(selectedUser);
    }
});

// Function to display a sent message immediately
function displaySentMessage(sender, recipient, message) {
    const messageElement = document.createElement('div');
    messageElement.innerHTML = `<strong>[You to ${recipient}]:</strong> ${message}`;
    messageElement.classList.add('sent-message', 'alert', 'alert-primary', 'my-2', 'py-2', 'px-3', 'rounded');
    chatMessages.appendChild(messageElement);
}

// Function to display conversation with a selected user or create a new one if it doesn't exist
function displayConversation(username) {
    // Clear chat messages
    chatMessages.innerHTML = '';

    // Display conversation header
    const conversationHeader = document.createElement('div');
    conversationHeader.innerHTML = `<h3 class="mb-0">Conversation with ${username}</h3>`;
    chatMessages.appendChild(conversationHeader);

    // Filter messages relevant to the selected user and display them
    const relevantMessages = messages.filter(message =>
        (message.sender === currentUser && message.recipient === username) ||
        (message.sender === username && message.recipient === currentUser)
    );

    relevantMessages.forEach(message => {
        const messageElement = document.createElement('div');
        if (message.sender === currentUser) {
            messageElement.innerHTML = `<strong>[You]:</strong> ${message.content}`;
        } else {
            messageElement.innerHTML = `<strong>[${message.sender}]:</strong> ${message.content}`;
        }
        messageElement.classList.add('sent-message', 'alert', 'alert-primary', 'my-2', 'py-2', 'px-3', 'rounded');
        chatMessages.appendChild(messageElement);
    });

    // Scroll to the bottom of the chat messages
    chatMessages.scrollTop = chatMessages.scrollHeight;
}


// Socket event listeners
socket.on('userExists', (message) => {
    alert(message);
});

socket.on('userList', (users) => {
    userList.innerHTML = '';
    users.forEach(user => {
        if (user !== currentUser) {
            const userElement = document.createElement('a');
            userElement.innerText = user;
            userElement.href = '#';
            userElement.classList.add('list-group-item', 'list-group-item-action');
            userList.appendChild(userElement);
        }
    });
});

socket.on('userJoined', (username) => {
    if (username !== currentUser) {
        const userElement = document.createElement('a');
        userElement.innerText = username;
        userElement.href = '#';
        userElement.classList.add('list-group-item', 'list-group-item-action');
        userList.appendChild(userElement);
    }
});

socket.on('userLeft', (username) => {
    const userElements = userList.querySelectorAll('.list-group-item');
    userElements.forEach(element => {
        if (element.innerText.trim() === username) {
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
        messageElement.classList.add('sent-message', 'alert', 'alert-primary', 'my-2', 'py-2', 'px-3', 'rounded');
        chatMessages.appendChild(messageElement);
        // Scroll to the bottom of the chat messages
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }
});

socket.on('open conversation', (sender) => {
    if (!selectedUser || selectedUser !== sender) {
        selectedUser = sender;
        displayConversation(selectedUser);
    }
});

socket.on('errorMessage', (message) => {
    alert(message);
});
