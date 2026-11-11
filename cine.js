document.addEventListener('DOMContentLoaded', () => {

  // 1. Filtro por género de películas
  const filterBtns = document.querySelectorAll('.filter-btn');
  const movieCards = document.querySelectorAll('.movie-card');

  filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      // Remover clase active de todos los botones
      filterBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      const genre = btn.dataset.genre;

      movieCards.forEach(card => {
        if (genre === 'all' || card.dataset.genre === genre) {
          card.style.display = 'flex';
        } else {
          card.style.display = 'none';
        }
      });
    });
  });

  // 2. Control de Modal para selección de funciones
  const modal = document.getElementById('ticketModal');
  const modalTitle = document.getElementById('modalMovieTitle');
  const closeBtn = document.querySelector('.modal-close');
  const showBtns = document.querySelectorAll('.movie-btn');

  showBtns.forEach(btn => {
    btn.addEventListener('click', (e) => {
      const card = e.target.closest('.movie-card');
      const movieTitle = card.querySelector('.movie-title').textContent;
      
      if (modalTitle) modalTitle.textContent = movieTitle;
      if (modal) modal.classList.add('open');
    });
  });

  if (closeBtn) {
    closeBtn.addEventListener('click', () => {
      modal.classList.remove('open');
    });
  }

  // Cerrar modal al hacer clic fuera del contenido
  window.addEventListener('click', (e) => {
    if (e.target === modal) {
      modal.classList.remove('open');
    }
  });

  // 3. Confirmación de Horario
  document.addEventListener('click', (e) => {
    if (e.target.classList.contains('schedule-btn')) {
      const time = e.target.textContent;
      alert(`Has seleccionado la función de las ${time}. ¡Redirigiendo a selección de butacas!`);
      if (modal) modal.classList.remove('open');
    }
  });

});

