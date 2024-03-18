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
            socket.emit('private message', { recipient: selectedUser, message });
            messageInput.value = '';
            const messageElement = document.createElement('div');
            messageElement.innerHTML = `<strong>[You to ${selectedUser}]:</strong> ${message}`;
            chatMessages.appendChild(messageElement);
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

// Function to display conversation with a selected user
function displayConversation(username) {
    chatMessages.innerHTML = '';
    chatContainer.style.display = 'block';
    authenticationContainer.style.display = 'none';
    const conversationDiv = document.createElement('div');
    conversationDiv.classList.add('conversation');
    conversationDiv.innerHTML = `<h3>Conversation with ${username}</h3>`;
    chatMessages.appendChild(conversationDiv);
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

// Store conversation elements in an object
const conversationElements = {};

// Function to display conversation with a selected user or create a new one if it doesn't exist
function displayConversation(username) {
    // Check if conversation element already exists
    if (!conversationElements[username]) {
        // Create a new conversation element
        const newConversationDiv = document.createElement('div');
        newConversationDiv.classList.add('conversation');
        newConversationDiv.innerHTML = `<h3>Conversation with ${username}</h3>`;
        chatMessages.appendChild(newConversationDiv);
        
        // Store the conversation element in the object
        conversationElements[username] = newConversationDiv;
    }
    
    // Display the selected conversation
    Object.values(conversationElements).forEach(conversation => {
        conversation.style.display = 'none';
    });
    conversationElements[username].style.display = 'block';
}

// Socket event listener for receiving private messages
socket.on('private message', ({ sender, message }) => {
    // Open conversation window for the sender
    displayConversation(sender);
    
    // Create message element and append it to the corresponding conversation
    const messageElement = document.createElement('div');
    messageElement.innerHTML = `<strong>[${sender}]:</strong> ${message}`;
    conversationElements[sender].appendChild(messageElement);
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
