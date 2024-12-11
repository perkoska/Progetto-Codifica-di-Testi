// Funzione per ridimensionare la mappa immagine
function resizeImageMap() {
    const images = document.querySelectorAll('.facsimile img');

    images.forEach(img => {
        const map = document.querySelector(`map[name="${img.useMap.slice(1)}"]`);
        const areas = map.querySelectorAll('area');

        const widthRatio = img.width / img.naturalWidth;
        const heightRatio = img.height / img.naturalHeight;

        areas.forEach(area => {
            const coords = area.dataset.coords.split(',');
            const newCoords = coords.map((coord, index) => {
                return index % 2 === 0
                    ? Math.round(parseInt(coord) * widthRatio)
                    : Math.round(parseInt(coord) * heightRatio);
            });

            area.coords = newCoords.join(',');
        });
    });
}

document.querySelectorAll('area').forEach(area => {
    area.addEventListener('click', handleAreaClick);
});

function handleAreaClick(e) {
    e.preventDefault();
    let targetId = this.getAttribute('href');

    // Rimuovi il carattere '#' iniziale se presente
    if (targetId.startsWith('#')) {
        targetId = targetId.substring(1);
    }

    // Prova prima a cercare l'elemento con l'ID che include '#'
    let targetElement = document.getElementById('#' + targetId);

    // Se non lo trova, prova senza il '#'
    if (!targetElement) {
        targetElement = document.getElementById(targetId);
    }

    console.log('ID cercato:', targetId);
    console.log('Elemento trovato:', targetElement);

    // Rimuovi l'evidenziazione precedente
    document.querySelectorAll('.highlight-target.active').forEach(el => {
        el.classList.remove('active');
    });

    // Aggiungi l'evidenziazione al nuovo elemento
    if (targetElement) {
        targetElement.classList.add('active');
        targetElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
    } else {
        console.log('Elemento non trovato:', targetId);
    }
}

// Funzione di inizializzazione
function initializeImageMap() {
    const facsimileAreas = document.querySelectorAll('area');

    facsimileAreas.forEach(area => {
        area.addEventListener('click', handleAreaClick);
    });

    resizeImageMap();
}

// Event listeners
window.addEventListener('load', initializeImageMap);
window.addEventListener('resize', resizeImageMap);
document.addEventListener('DOMContentLoaded', initializeImageMap);

//Colora i diversi fenomeni
document.addEventListener('DOMContentLoaded', function () {
    const phenomena = {
        'person': { class: 'person', color: '#FFB3BA' },
        'place': { class: 'place', color: '#BAFFC9' },
        'role': { class: 'role', color: '#BAE1FF' },
        'organization': { class: 'organization', color: '#FFFFBA' }
    };

    const buttons = document.querySelectorAll('.phenomenon-btn');

    buttons.forEach(button => {
        button.addEventListener('click', function () {
            const phenomenon = this.getAttribute('data-phenomenon');
            toggleHighlight(phenomenon);
            animateButton(this);
        });
    });

    function toggleHighlight(phenomenon) {
        const elements = document.getElementsByClassName(phenomena[phenomenon].class);
        for (let el of elements) {
            el.style.backgroundColor = el.style.backgroundColor ? '' : phenomena[phenomenon].color;
        }
    }

    function animateButton(button) {
        button.classList.add('clicked');
        setTimeout(() => {
            button.classList.remove('clicked');
        }, 300);
    }
});