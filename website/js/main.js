// main.js - loads dummy news articles dynamically

const articles = [
    {
        title: "Football: Arsenal Host Everton Amid Triple Title Pursuit",
        content: " The Premier League title race heats up tonight as league leaders Arsenal host Everton at the Emirates. Having topped the table since October, Mikel Arteta’s side is currently chasing a historic quadruple, with a Carabao Cup final against Manchester City scheduled for later this month. Meanwhile, transfer rumors are swirling that Atletico Madrid striker Julian Alvarez has given the 'green light' for a blockbuster return to the Premier League with the Gunners this summer."
    },
    {
        title: "Fashion: The 'Upcycled' Revolution Hits $12B",
        content: "Sustainability is dominating the runway this week as the global upcycled fashion market is projected to reach over $12 billion. Major brands are shifting away from traditional recycling toward true upcycling—transforming post-consumer garments into high-end outerwear and denim without losing the original material's integrity. Mens upcycled fashion is currently the fastest-growing segment, rising at a rate of 10% annually."
    },
    {
        title: "Automobile: Mercedes Redefines Luxury with the CLA 250+",
        content: "All artMercedes-Benz is making waves with the official first drives of the 2026 CLA 250+. Positioned as a 'next-gen' electric sedan, it’s grabbing headlines for its impressive 800km range and a new AI-powered software stack. It represents a major pivot for the brand, aiming to bring high-end autonomous features and massive range to a more 'entry-level' luxury price point.icles and blog content are unique and created specifically for this project."
    }
];

const articlesContainer = document.getElementById('articles');

articles.forEach(article => {
    const articleDiv = document.createElement('div');
    articleDiv.className = 'article';

    const articleTitle = document.createElement('h3');
    articleTitle.textContent = article.title;

    const articleContent = document.createElement('p');
    articleContent.textContent = article.content;

    articleDiv.appendChild(articleTitle);
    articleDiv.appendChild(articleContent);

    articlesContainer.appendChild(articleDiv);
});