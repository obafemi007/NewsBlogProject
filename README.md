
## ** README.md**


```markdown
#  News Blog - Static Website Deployment

## 1. Project Overview
This in an Individual project for Group 5 **Group 5: Static Website Deployment** .  
We deployed a unique news blog using **AWS EC2** and **NGINX**. The site displays dynamic news articles using JavaScript.

---

## 2. Architecture
- **EC2 Instance (Ubuntu 22.04)**: Hosts the web server.
- **NGINX**: Serves static website files.
- **Website Files**: HTML, CSS, JS in `/var/www/group5newsblog`.

```

User --> Browser --> EC2 (NGINX) --> index.html / about.html / JS / CSS

```

---

## 3. Website Structure

```

project-root/
│── index.html
│── about.html
│── css/
│    └── styles.css
└── js/
└── main.js

````

- `index.html` → Home page with latest news
- `about.html` → About page
- `css/styles.css` → Styling
- `js/main.js` → Loads news dynamically

---

## 4. Deployment Instructions

### 4.1 Launch EC2 Instance
1. Use **Ubuntu 22.04 LTS** on **AWS EC2** (free tier is sufficient).  
2. Create a **Security Group** allowing ports **22, 80, 443**.  
3. SSH into the instance:
```bash
ssh -i "Group5Key.pem" ubuntu@<EC2_PUBLIC_IP>
````

### 4.2 Upload Files

From your local machine:

```bash
scp -i "Group5Key.pem" -r index.html about.html css js deploy.sh ubuntu@<EC2_PUBLIC_IP>:/home/ubuntu/
```

### 4.3 Run Deployment Script

```bash
chmod +x deploy.sh
./deploy.sh
```

> Your website will be available at `http://<EC2_PUBLIC_IP>`

---

## 5. Screenshots

*(Add screenshots here after deploying your site)*

* **Home Page Screenshot**
* **About Page Screenshot**
* **NGINX status on EC2**
* **Terminal showing deploy.sh running successfully**

---

## 6. Challenges & Solutions

* **File Permissions**: Resolved using `chown` to allow NGINX to read files.
* **Dynamic Content Loading**: Ensured JS runs properly on NGINX by placing `js/main.js` in `/var/www/group5newsblog/js`.

---

## 7. GitHub Repository

**Repository Link:** [Add your GitHub link here]

Folder structure in GitHub:

```
Group5-NewsBlog/
│── index.html
│── about.html
│── css/
│── js/
└── deploy.sh
```

---

## 8. Bonus (Optional)

* Set up **GitHub Actions** to auto-deploy on EC2 whenever new code is pushed.
* Add SSL certificate via **Let's Encrypt** for HTTPS (port 443).

---

## 9. Conclusion

The static site is fully functional, hosted on AWS EC2, accessible through a public IP, and includes automation for deployment using `deploy.sh`.

```

---

✅ **Next Steps for You**
1. Create `deploy.sh` and `README.md` in VSCode in your project root.  
2. Make sure your folder has `index.html`, `about.html`, `css/styles.css`, `js/main.js`.  
3. Upload to EC2 and run `deploy.sh`.  
4. Take screenshots for documentation placeholders.  
5. Push the project folder to GitHub.  

---

If you want, I can also **write the GitHub Actions workflow** that auto-deploys your site every time you push — this will make it completely automated for bonus points.  

Do you want me to do that?
```
