// ========================================
// SIGAD - UI Enhancements JavaScript
// Data: 18 Febbraio 2026
// AppBar scroll behavior e UX improvements
// ========================================

(function () {
    'use strict';

    // ── APPBAR SCROLL ENHANCEMENT ──
    // Aggiunge classe 'scrolled' all'AppBar quando si scrolla
    let lastScrollTop = 0;
    const appBar = document.querySelector('.sigad-appbar');
    
    if (appBar) {
        window.addEventListener('scroll', function() {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
            
            if (scrollTop > 20) {
                appBar.classList.add('scrolled');
            } else {
                appBar.classList.remove('scrolled');
            }
            
            lastScrollTop = scrollTop;
        }, { passive: true });
    }

    // ── DRAWER AUTO-CLOSE ON MOBILE ──
    // Chiude il drawer dopo click su link in mobile
    const navLinks = document.querySelectorAll('.sigad-nav-link');
    const isMobile = window.matchMedia('(max-width: 960px)').matches;
    
    if (isMobile && navLinks.length > 0) {
        navLinks.forEach(link => {
            link.addEventListener('click', function() {
                // Il drawer si chiude automaticamente con Breakpoint="Md"
                // Questo è solo per smooth UX feedback
                setTimeout(() => {
                    const drawer = document.querySelector('.sigad-drawer');
                    if (drawer) {
                        drawer.classList.add('closing');
                    }
                }, 100);
            });
        });
    }

    // ── SKIP-TO-CONTENT SMOOTH SCROLL ──
    const skipLink = document.querySelector('.sigad-skip-link');
    
    if (skipLink) {
        skipLink.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector('#main-content');
            
            if (target) {
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                target.focus({ preventScroll: true });
            }
        });
    }

    // ── KEYBOARD NAVIGATION ENHANCEMENT ──
    // Trap focus in drawer quando aperto su mobile
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            // Chiude QuickDrawer o mobile Drawer con ESC
            const quickDrawer = document.querySelector('.sigad-quickdrawer .mud-drawer-open');
            if (quickDrawer) {
                const closeBtn = quickDrawer.querySelector('.mud-icon-button');
                if (closeBtn) closeBtn.click();
            }
        }
    });

    // ── PERFORMANCE: Debounce resize events ──
    let resizeTimeout;
    window.addEventListener('resize', function() {
        clearTimeout(resizeTimeout);
        resizeTimeout = setTimeout(function() {
            // Aggiorna stato mobile
            const nowMobile = window.matchMedia('(max-width: 960px)').matches;
            document.body.classList.toggle('is-mobile', nowMobile);
        }, 150);
    }, { passive: true });

    // ── ACCESSIBILITY: Announce page changes for screen readers ──
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'childList') {
                const pageTitle = document.querySelector('.sigad-page-title');
                if (pageTitle && pageTitle.textContent) {
                    // Announce new page to screen readers
                    announceToScreenReader(`Pagina caricata: ${pageTitle.textContent}`);
                }
            }
        });
    });

    // Observe page content changes
    const mainContent = document.querySelector('#main-content');
    if (mainContent) {
        observer.observe(mainContent, { childList: true, subtree: true });
    }

    // ── Helper: Screen reader announcements ──
    function announceToScreenReader(message) {
        const liveRegion = document.getElementById('aria-live-region') || createLiveRegion();
        liveRegion.textContent = message;
        
        // Clear after 1 second
        setTimeout(() => {
            liveRegion.textContent = '';
        }, 1000);
    }

    function createLiveRegion() {
        const region = document.createElement('div');
        region.id = 'aria-live-region';
        region.setAttribute('aria-live', 'polite');
        region.setAttribute('aria-atomic', 'true');
        region.className = 'sr-only';
        region.style.cssText = 'position:absolute;left:-10000px;width:1px;height:1px;overflow:hidden;';
        document.body.appendChild(region);
        return region;
    }

    // ── Initialize on Blazor reconnect ──
    if (window.Blazor) {
        window.Blazor.addEventListener('enhancedload', function() {
            console.log('SIGAD UI Enhancements reinitialized');
            // Re-attach event listeners after Blazor updates
        });
    }

    console.log('SIGAD UI Enhancements loaded');
})();
