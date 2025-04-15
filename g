<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portfolio - [Your Name]</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto+Mono:wght@300;400;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <!-- Three.js for 3D Animations -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r134/three.min.js"></script>
    <!-- Custom CSS -->
    <style>
        :root {
            --primary-color: #8b5cf6; /* Royal purple */
            --secondary-color: #facc15; /* Golden yellow */
            --text-color: #e5e7eb; /* Soft gray */
            --bg-color: #111827; /* Deep navy */
            --accent-color: #38bdf8; /* Sky blue */
            --card-bg: rgba(255, 255, 255, 0.05);
            --shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        body {
            font-family: 'Roboto Mono', monospace;
            background-color: var(--bg-color);
            color: var(--text-color);
            scroll-behavior: smooth;
            overflow-x: hidden;
        }

        /* Splash Screen */
        #splash-screen {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            opacity: 1;
            transition: opacity 0.5s ease;
        }

        #splash-screen h1 {
            font-size: 3rem;
            font-weight: 700;
            background: linear-gradient(45deg, #fff, var(--accent-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .loader {
            border: 5px solid #fff;
            border-top: 5px solid var(--accent-color);
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Navbar */
        .navbar {
            background: var(--card-bg);
            backdrop-filter: blur(15px);
            padding: 20px 0;
            position: fixed;
            width: 100%;
            z-index: 1000;
            transition: transform 0.3s ease;
        }

        .navbar-hidden {
            transform: translateY(-100%);
        }

        .navbar-brand {
            font-size: 1.8rem;
            font-weight: 700;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .nav-link {
            color: var(--text-color) !important;
            font-size: 1.1rem;
            position: relative;
            transition: color 0.3s ease;
        }

        .nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 3px;
            bottom: -5px;
            left: 0;
            background: var(--accent-color);
            transition: width 0.3s ease;
        }

        .nav-link:hover::after,
        .nav-link.active::after {
            width: 100%;
        }

        /* Hero Section */
        .hero-section {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        #three-canvas {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
        }

        .hero-content {
            text-align: center;
            z-index: 1;
        }

        .hero-content h1 {
            font-size: 4.5rem;
            font-weight: 700;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: fadeIn 2s ease;
        }

        .hero-content p {
            font-size: 1.8rem;
            margin: 20px 0;
            color: var(--text-color);
            opacity: 0.9;
        }

        .btn-custom {
            background: linear-gradient(45deg, var(--primary-color), var(--accent-color));
            color: #fff;
            padding: 15px 40px;
            font-size: 1.2rem;
            border-radius: 50px;
            border: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .btn-custom:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow);
        }

        /* About Section */
        .about-section {
            padding: 150px 0;
            background: linear-gradient(180deg, var(--bg-color), #1f2937);
        }

        .about-section h2 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 40px;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .about-section p {
            font-size: 1.2rem;
            line-height: 1.9;
            opacity: 0.85;
        }

        .about-img {
            border-radius: 20px;
            box-shadow: var(--shadow);
            border: 2px solid var(--accent-color);
            transition: transform 0.5s ease;
        }

        .about-img:hover {
            transform: scale(1.05);
        }

        /* Skills Section */
        .skills-section {
            padding: 150px 0;
            background: var(--bg-color);
        }

        .skills-section h2 {
            font-size: 3.5rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 60px;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .skill-card {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            border: 1px solid var(--accent-color);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .skill-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 20px rgba(139, 92, 246, 0.3);
        }

        .skill-card i {
            font-size: 3rem;
            color: var(--secondary-color);
            margin-bottom: 20px;
        }

        .skill-card h5 {
            color: var(--accent-color);
        }

        /* Experience Section */
        .experience-section {
            padding: 150px 0;
            background: linear-gradient(180deg, #1f2937, var(--bg-color));
        }

        .experience-section h2 {
            font-size: 3.5rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 60px;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .timeline {
            position: relative;
            max-width: 800px;
            margin: 0 auto;
        }

        .timeline::before {
            content: '';
            position: absolute;
            top: 0;
            bottom: 0;
            left: 50%;
            width: 4px;
            background: var(--accent-color);
            transform: translateX(-50%);
        }

        .timeline-item {
            position: relative;
            margin: 40px 0;
            width: 50%;
        }

        .timeline-item.left {
            left: 0;
        }

        .timeline-item.right {
            left: 50%;
        }

        .timeline-content {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 10px;
            box-shadow: var(--shadow);
            position: relative;
            border: 1px solid var(--accent-color);
        }

        .timeline-content::before {
            content: '';
            position: absolute;
            top: 20px;
            width: 0;
            height: 0;
            border: 10px solid transparent;
        }

        .left .timeline-content::before {
            right: -20px;
            border-left-color: var(--card-bg);
        }

        .right .timeline-content::before {
            left: -20px;
            border-right-color: var(--card-bg);
        }

        .timeline-dot {
            position: absolute;
            top: 20px;
            width: 20px;
            height: 20px;
            background: var(--secondary-color);
            border-radius: 50%;
            box-shadow: 0 0 10px var(--secondary-color);
        }

        .left .timeline-dot {
            right: -10px;
        }

        .right .timeline-dot {
            left: -10px;
        }

        /* Portfolio Section */
        .portfolio-section {
            padding: 150px 0;
            background: var(--bg-color);
        }

        .portfolio-section h2 {
            font-size: 3.5rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 60px;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .portfolio-item {
            position: relative;
            overflow: hidden;
            border-radius: 15px;
            box-shadow: var(--shadow);
            transition: transform 0.5s ease;
        }

        .portfolio-item:hover {
            transform: translateY(-10px);
        }

        .portfolio-item img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .portfolio-item:hover img {
            transform: scale(1.1);
        }

        .portfolio-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.8), rgba(56, 189, 248, 0.8));
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .portfolio-item:hover .portfolio-overlay {
            opacity: 1;
        }

        .portfolio-overlay h5 {
            color: var(--secondary-color);
        }

        .portfolio-overlay p,
        .portfolio-overlay a {
            color: #fff;
            text-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
        }

        .portfolio-overlay a {
            font-size: 1.1rem;
            margin-top: 10px;
            text-decoration: none;
            border: 1px solid var(--secondary-color);
            padding: 8px 20px;
            border-radius: 50px;
            transition: background 0.3s ease;
        }

        .portfolio-overlay a:hover {
            background: var(--secondary-color);
            color: var(--bg-color);
        }

        /* Contact Section */
        .contact-section {
            padding: 150px 0;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
        }

        .contact-section h2 {
            font-size: 3.5rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 40px;
            color: #fff;
        }

        .form-control {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 10px;
            padding: 15px;
            font-size: 1.1rem;
            color: #fff;
        }

        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .form-control:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 10px rgba(250, 204, 21, 0.3);
        }

        .btn-submit {
            background: var(--secondary-color);
            color: var(--bg-color);
            padding: 15px 40px;
            font-size: 1.2rem;
            border-radius: 50px;
            border: none;
            transition: all 0.3s ease;
        }

        .btn-submit:hover {
            background: var(--accent-color);
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(56, 189, 248, 0.3);
        }

        /* Footer */
        footer {
            background: var(--bg-color);
            padding: 60px 0;
            text-align: center;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        footer a {
            color: var(--accent-color);
            font-size: 1.8rem;
            margin: 0 15px;
            transition: color 0.3s ease;
        }

        footer a:hover {
            color: var(--secondary-color);
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-on-scroll {
            opacity: 0;
            transform: translateY(30px);
            transition: opacity 0.8s ease, transform 0.8s ease;
        }

        .animate-on-scroll.visible {
            opacity: 1;
            transform: translateY(0);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero-content h1 {
                font-size: 2.5rem;
            }

            .hero-content p {
                font-size: 1.3rem;
            }

            .about-section h2,
            .skills-section h2,
            .experience-section h2,
            .portfolio-section h2,
            .contact-section h2 {
                font-size: 2.5rem;
            }

            .portfolio-item img {
                height: 200px;
            }

            .timeline::before {
                left: 20px;
            }

            .timeline-item {
                width: 100%;
                left: 0 !important;
            }

            .timeline-content::before {
                left: -20px !important;
                border-right-color: var(--card-bg) !important;
                border-left-color: transparent !important;
            }

            .timeline-dot {
                left: 10px !important;
                right: auto !important;
            }
        }
    </style>
</head>
<body>
    <!-- Splash Screen -->
    <div id="splash-screen">
        <h1>Welcome to My Portfolio</h1>
        <div class="loader"></div>
    </div>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="#">[Your Name]</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="#home">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#about">About</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#skills">Skills</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#experience">Experience</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#portfolio">Portfolio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#contact">Contact</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section id="home" class="hero-section">
        <div id="three-canvas"></div>
        <div class="hero-content">
            <h1>Web Developer & Network Engineer</h1>
            <p>From Jijel, Algeria | Crafting Digital Excellence</p>
            <a href="#contact" class="btn btn-custom">Connect with Me</a>
        </div>
    </section>

    <!-- About Section -->
    <section id="about" class="about-section">
        <div class="container">
            <div class="row align-items-center animate-on-scroll">
                <div class="col-lg-6">
                    <h2>About Me</h2>
                    <p>
                        I'm [Your Name], a web developer and networks & telecommunications engineer from Jijel, Algeria. I graduated from École Nationale Polytechnique d'Oran, mastering network systems and telecommunications.
                    </p>
                    <p>
                        Skilled in HTML, CSS, JavaScript, Bootstrap, Node.js, and MySQL, I create dynamic web applications. My three internships at Djezzy Algérie sharpened my expertise in network optimization and project execution. I’m passionate about blending tech and creativity to build solutions that inspire.
                    </p>
                </div>
                <div class="col-lg-6 text-center">
                    <img src="https://via.placeholder.com/400" class="img-fluid about-img" alt="Profile Image">
                </div>
            </div>
        </div>
    </section>

    <!-- Skills Section -->
    <section id="skills" class="skills    <div class="container">
        <h2 class="animate-on-scroll">My Skills</h2>
        <div class="row">
            <div class="col-md-4 animate-on-scroll">
                <div class="skill-card">
                    <i class="fab fa-html5"></i>
                    <h5>HTML & CSS</h5>
                    <p>Designing responsive, visually appealing web interfaces.</p>
                </div>
            </div>
            <div class="col-md-4 animate-on-scroll">
                <div class="skill-card">
                    <i class="fab fa-js"></i>
                    <h5>JavaScript & Node.js</h5>
                    <p>Building interactive, server-side applications.</p>
                </div>
            </div>
            <div class="col-md-4 animate-on-scroll">
                <div class="skill-card">
                    <i class="fas fa-database"></i>
                    <h5>MySQL</h5>
                    <p>Managing robust, scalable databases.</p>
                </div>
            </div>
            <div class="col-md-4 animate-on-scroll">
                <div class="skill-card">
                    <i class="fas fa-network-wired"></i>
                    <h5>Networking</h5>
                    <p>Optimizing telecom and network infrastructure.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Experience Section -->
    <section id="experience" class="experience-section">
        <div class="container">
            <h2 class="animate-on-scroll">My Journey</h2>
            <div class="timeline">
                <div class="timeline-item left animate-on-scroll">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <h5>2019 - Internship at Djezzy Algérie</h5>
                        <p>Supported network setup and troubleshooting for mobile services.</p>
                    </div>
                </div>
                <div class="timeline-item right animate-on-scroll">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <h5>2020 - Internship at Djezzy Algérie</h5>
                        <p>Enhanced 4G network performance through data analysis.</p>
                    </div>
                </div>
                <div class="timeline-item left animate-on-scroll">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <h5>2021 - Internship at Djezzy Algérie</h5>
                        <p>Coordinated a project to expand network coverage in rural Algeria.</p>
                    </div>
                </div>
                <div class="timeline-item right animate-on-scroll">
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <h5>2022 - Graduated from École Nationale Polytechnique d'Oran</h5>
                        <p>Completed degree in Networks & Telecommunications Engineering.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Portfolio Section -->
    <section id="portfolio" class="portfolio-section">
        <div class="container">
            <h2 class="animate-on-scroll">My Projects</h2>
            <div class="row">
                <div class="col-md-4 animate-on-scroll">
                    <div class="portfolio-item">
                        <img src="https://via.placeholder.com/400x300?text=Chat+App" alt="Chat App">
                        <div class="portfolio-overlay">
                            <h5>Arab Chat</h5>
                            <p>Real-time chat platform using Node.js and MySQL.</p>
                            <a href="#" target="_blank">View Project</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 animate-on-scroll">
                    <div class="portfolio-item">
                        <img src="https://via.placeholder.com/400x300?text=E-Commerce" alt="E-Commerce">
                        <div class="portfolio-overlay">
                            <h5>E-Commerce Platform</h5>
                            <p>Online store with secure payment gateways.</p>
                            <a href="#" target="_blank">View Project</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 animate-on-scroll">
                    <div class="portfolio-item">
                        <img src="https://via.placeholder.com/400x300?text=Network+Tool" alt="Network Tool">
                        <div class="portfolio-overlay">
                            <h5>Network Dashboard</h5>
                            <p>Tool for monitoring network performance in real-time.</p>
                            <a href="#" target="_blank">View Project</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" class="contact-section">
        <div class="container">
            <h2 class="animate-on-scroll">Get in Touch</h2>
            <div class="row justify-content-center">
                <div class="col-lg-6 animate-on-scroll">
                    <form id="contactForm">
                        <div class="mb-4">
                            <input type="text" class="form-control" id="name" placeholder="Your Name" required>
                        </div>
                        <div class="mb-4">
                            <input type="email" class="form-control" id="email" placeholder="Your Email" required>
                        </div>
                        <div class="mb-4">
                            <textarea class="form-control" id="message" rows="6" placeholder="Your Message" required></textarea>
                        </div>
                        <div class="text-center">
                            <button type="submit" class="btn btn-submit">Send Message</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <p>© 2025 [Your Name] | Jijel, Algeria</p>
            <div class="social-links">
                <a href="#" target="_blank"><i class="fab fa-linkedin"></i></a>
                <a href="#" target="_blank"><i class="fab fa-github"></i></a>
                <a href="#" target="_blank"><i class="fab fa-twitter"></i></a>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"></script>
    <!-- Custom JavaScript -->
    <script>
        // Splash Screen
        window.addEventListener('load', () => {
            const splash = document.getElementById('splash-screen');
            setTimeout(() => {
                splash.style.opacity = '0';
                setTimeout(() => {
                    splash.style.display = 'none';
                }, 500);
            }, 2000);
        });

        // Three.js Hero Animation
        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        const renderer = new THREE.WebGLRenderer({ alpha: true });
        renderer.setSize(window.innerWidth, window.innerHeight);
        document.getElementById('three-canvas').appendChild(renderer.domElement);

        const geometry = new THREE.IcosahedronGeometry(10, 1);
        const material = new THREE.MeshBasicMaterial({
            color: 0x8b5cf6,
            wireframe: true
        });
        const icosahedron = new THREE.Mesh(geometry, material);
        scene.add(icosahedron);

        camera.position.z = 20;

        function animate() {
            requestAnimationFrame(animate);
            icosahedron.rotation.x += 0.01;
            icosahedron.rotation.y += 0.01;
            renderer.render(scene, camera);
        }
        animate();

        window.addEventListener('resize', () => {
            renderer.setSize(window.innerWidth, window.innerHeight);
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
        });

        // Navbar Scroll Effect
        let lastScroll = 0;
        window.addEventListener('scroll', () => {
            const currentScroll = window.pageYOffset;
            const navbar = document.querySelector('.navbar');
            if (currentScroll > lastScroll && currentScroll > 100) {
                navbar.classList.add('navbar-hidden');
            } else {
                navbar.classList.remove('navbar-hidden');
            }
            lastScroll = currentScroll;
        });

        // Scroll Animations
        const animateElements = document.querySelectorAll('.animate-on-scroll');
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                }
            });
        }, { threshold: 0.1 });

        animateElements.forEach(el => observer.observe(el));

        // Smooth Scroll
        document.querySelectorAll('.nav-link').forEach(anchor => {
            anchor.addEventListener('click', function(e) {
                e.preventDefault();
                const targetId = this.getAttribute('href').substring(1);
                const targetElement = document.getElementById(targetId);
                window.scrollTo({
                    top: targetElement.offsetTop - 80,
                    behavior: 'smooth'
                });
                document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
                this.classList.add('active');
            });
        });

        // Form Submission
        document.getElementById('contactForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const name = document.getElementById('name').value;
            alert(`Thank you, ${name}! Your message has been sent.`);
            this.reset();
        });
    </script>
</body>
</html>