const counter = document.getElementById("counter");

const updateCounter = async () => {
    const data = await fetch(
        "https://counter.malbertini.ovh/increment"
    );
    const count = await data.json();
    counter.innerHTML = count.N;
    counter.style.filter = "blur(0)";
};

updateCounter();
