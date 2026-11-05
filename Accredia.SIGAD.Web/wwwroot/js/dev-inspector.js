(function () {
  if (window.portalDevInspector) {
    return;
  }

  var toggleHotkeyLabel = "Ctrl+Alt+D";
  var saveHotkeyLabel = "Ctrl+Alt+S";
  var state = {
    initialized: false,
    enabled: false,
    locked: false,
    selectedElement: null,
    hoverElement: null,
    overlay: null,
    panel: null,
    statusNode: null,
    elementNode: null,
    routeNode: null,
    componentListNode: null,
    componentWarningNode: null,
    cssListNode: null,
    titleNode: null,
    requestNode: null,
    changeTypeNode: null,
    targetComponentNode: null,
    currentStateNode: null,
    targetStateNode: null,
    invariantsNode: null,
    constraintsNode: null,
    referencesNode: null,
    acceptanceVisualNode: null,
    acceptanceBehaviorNode: null,
    acceptanceInvariantsNode: null,
    acceptanceRejectNode: null,
    saveButtonNode: null,
    saveStatusNode: null,
    screenshotButtonNode: null,
    screenshotClearButtonNode: null,
    screenshotStatusNode: null,
    screenshotPreviewNode: null,
    screenshotBlob: null,
    isDragging: false,
    dragOffsetX: 0,
    dragOffsetY: 0,
    activeTab: "modifica",
    noteTipoNode: null,
    noteTitoloNode: null,
    noteContenutoNode: null,
    noteTagNode: null,
    noteSeverityNode: null,
    noteStatoNode: null,
    noteRiferimentiNode: null,
    noteSeverityWrapNode: null,
    noteStatoWrapNode: null
  };

  var NOTE_CONTENT_TEMPLATES = {
    "DECISIONE": "Decisione presa:\n\nContesto:\n\nAlternative considerate:\n\nConseguenze attese:",
    "BUG_TODO": "Comportamento osservato:\n\nComportamento atteso:\n\nRiproduzione (passi):\n\nWorkaround temporaneo (se presente):",
    "DOMANDA": "Domanda:\n\nContesto:\n\nIpotesi attuale:\n\nDa verificare con / dove cercare:",
    "KNOWLEDGE": "Cosa:\n\nCome funziona:\n\nFile / componenti coinvolti:\n\nNote ulteriori:"
  };

  function init() {
    if (state.initialized) {
      return;
    }

    state.initialized = true;
    createUi();

    document.addEventListener("keydown", onKeyDown, true);
    document.addEventListener("mousemove", onMouseMove, true);
    document.addEventListener("click", onClick, true);
    window.addEventListener("scroll", onScroll, true);
    window.addEventListener("resize", onResize, true);

    renderPanel();
  }

  function createUi() {
    var overlay = document.createElement("div");
    overlay.id = "portal-dev-inspector-highlight";
    overlay.setAttribute("data-dev-inspector-ui", "true");
    document.body.appendChild(overlay);
    state.overlay = overlay;

    var panel = document.createElement("aside");
    panel.id = "portal-dev-inspector-panel";
    panel.setAttribute("data-dev-inspector-ui", "true");
    panel.innerHTML =
      '<div class="portal-dev-inspector__header" data-role="drag-handle" title="Trascina per spostare il pannello">' +
      '<span class="portal-dev-inspector__grip" aria-hidden="true"></span>' +
      '<p class="portal-dev-inspector__title">Portal Dev Inspector</p>' +
      '<p class="portal-dev-inspector__sub">Toggle: ' + toggleHotkeyLabel + " | Save: " + saveHotkeyLabel + " | ESC: reset lock/disable</p>" +
      "</div>" +
      '<div class="portal-dev-inspector__body">' +
      '<div class="portal-dev-inspector__block"><p class="portal-dev-inspector__label">Status</p><p class="portal-dev-inspector__value" data-role="status"></p></div>' +
      '<div class="portal-dev-inspector__block"><p class="portal-dev-inspector__label">Elemento</p><p class="portal-dev-inspector__value" data-role="element"></p></div>' +
      '<div class="portal-dev-inspector__block"><p class="portal-dev-inspector__label">Route</p><p class="portal-dev-inspector__value" data-role="route"></p></div>' +
      '<div class="portal-dev-inspector__block">' +
      '<p class="portal-dev-inspector__label">Catena componenti</p>' +
      '<ol class="portal-dev-inspector__list" data-role="components"></ol>' +
      '<p class="portal-dev-inspector__component-warning" data-role="component-warning" hidden></p>' +
      '</div>' +
      '<div class="portal-dev-inspector__block"><p class="portal-dev-inspector__label">CSS matchati</p><ol class="portal-dev-inspector__list" data-role="css"></ol></div>' +
      '<div class="portal-dev-inspector__block">' +

      '<div class="portal-dev-inspector__tabs" role="tablist">' +
      '<button type="button" class="portal-dev-inspector__tab" data-tab-btn="modifica" data-active="true" role="tab">Modifica</button>' +
      '<button type="button" class="portal-dev-inspector__tab" data-tab-btn="appunto" data-active="false" role="tab">Appunto</button>' +
      '</div>' +

      '<div data-tab-panel="modifica">' +

      '<input class="portal-dev-inspector__input" data-role="title" type="text" placeholder="Titolo richiesta (opzionale)" />' +

      '<p class="portal-dev-inspector__field-label">Tipo modifica <span class="portal-dev-inspector__required">*</span></p>' +
      '<select class="portal-dev-inspector__select" data-role="change-type">' +
      '<option value="">— seleziona —</option>' +
      '<option value="VISUALE">Visuale / Layout</option>' +
      '<option value="FUNZIONALE">Funzionale / Comportamento</option>' +
      '<option value="MISTA">Mista (visuale + funzionale)</option>' +
      '<option value="NUOVO_COMPONENTE">Nuovo componente</option>' +
      '<option value="INTEGRAZIONE">Integrazione dati / API</option>' +
      '</select>' +

      '<p class="portal-dev-inspector__field-label">Componente sorgente da modificare <span class="portal-dev-inspector__required">*</span></p>' +
      '<select class="portal-dev-inspector__select" data-role="target-component"><option value="">— seleziona elemento prima —</option></select>' +

      '<p class="portal-dev-inspector__field-label">Modifica richiesta — cosa deve cambiare e perché <span class="portal-dev-inspector__required">*</span></p>' +
      '<textarea class="portal-dev-inspector__textarea" data-role="request" placeholder="Descrivi la modifica in modo preciso. Indica cosa deve essere diverso rispetto allo stato attuale."></textarea>' +

      '<p class="portal-dev-inspector__field-label">Stato attuale</p>' +
      '<textarea class="portal-dev-inspector__textarea portal-dev-inspector__textarea--small" data-role="current-state" placeholder="Com\'è adesso: layout, dati mostrati, comportamento corrente."></textarea>' +

      '<p class="portal-dev-inspector__field-label">Stato target</p>' +
      '<textarea class="portal-dev-inspector__textarea portal-dev-inspector__textarea--small" data-role="target-state" placeholder="Com\'è dopo la modifica: posizione elementi, proporzioni, sequenza azioni attese."></textarea>' +

      '<p class="portal-dev-inspector__field-label">Invarianti — cosa NON deve cambiare o rompersi</p>' +
      '<textarea class="portal-dev-inspector__textarea portal-dev-inspector__textarea--small" data-role="invariants" placeholder="es. Il conteggio certificati rimane visibile. Il layout non si rompe sotto 1280px. Gli stati loading/error rimangono gestiti."></textarea>' +

      '<p class="portal-dev-inspector__field-label">Vincoli tecnici</p>' +
      '<textarea class="portal-dev-inspector__textarea portal-dev-inspector__textarea--small" data-role="constraints" placeholder="es. Usare solo MudStack/MudGrid. Non toccare StagingService. Nessun CSS inline."></textarea>' +

      '<p class="portal-dev-inspector__field-label">Riferimenti (decision log, architettura, ticket)</p>' +
      '<input class="portal-dev-inspector__input" data-role="references" type="text" placeholder="es. UX34, UX35, D11 — oppure lascia vuoto" />' +

      '<p class="portal-dev-inspector__field-label portal-dev-inspector__field-label--section">Criteri di accettazione</p>' +

      '<p class="portal-dev-inspector__field-label">✅ Stato visivo finale</p>' +
      '<textarea class="portal-dev-inspector__textarea portal-dev-inspector__textarea--small" data-role="acceptance-visual" placeholder="es. Lo stepper occupa tutta la larghezza della content region. L\'area temporanea è sotto, non affiancata."></textarea>' +

      '<p class="portal-dev-inspector__field-label">✅ Comportamento / interazione</p>' +
      '<textarea class="portal-dev-inspector__textarea portal-dev-inspector__textarea--small" data-role="acceptance-behavior" placeholder="es. Il click su Avanti avanza allo step successivo senza ricaricare la pagina."></textarea>' +

      '<p class="portal-dev-inspector__field-label">❌ Condizioni di rifiuto</p>' +
      '<textarea class="portal-dev-inspector__textarea portal-dev-inspector__textarea--small" data-role="acceptance-reject" placeholder="es. Se lo stepper non è full-width la modifica è incompleta. Se l\'area appare a destra è errata."></textarea>' +

      '</div>' +

      '<div data-tab-panel="appunto" hidden>' +

      '<p class="portal-dev-inspector__field-label">Tipo appunto <span class="portal-dev-inspector__required">*</span></p>' +
      '<select class="portal-dev-inspector__select" data-role="note-tipo">' +
      '<option value="">— seleziona —</option>' +
      '<option value="DECISIONE">Decisione / contesto architetturale</option>' +
      '<option value="BUG_TODO">Bug noto / TODO / debito tecnico</option>' +
      '<option value="DOMANDA">Domanda aperta / da capire</option>' +
      '<option value="KNOWLEDGE">Knowledge transfer / onboarding</option>' +
      '</select>' +

      '<p class="portal-dev-inspector__field-label">Titolo <span class="portal-dev-inspector__required">*</span></p>' +
      '<input class="portal-dev-inspector__input" data-role="note-titolo" type="text" placeholder="Una riga, sintetica" />' +

      '<p class="portal-dev-inspector__field-label">Contenuto <span class="portal-dev-inspector__required">*</span></p>' +
      '<textarea class="portal-dev-inspector__textarea" data-role="note-contenuto" placeholder="Seleziona prima il tipo per vedere il template guidato."></textarea>' +

      '<p class="portal-dev-inspector__field-label">Tag (separati da virgola)</p>' +
      '<input class="portal-dev-inspector__input" data-role="note-tag" type="text" placeholder="es. paginazione, performance, organismi" />' +

      '<div data-role="note-severity-wrap" hidden>' +
      '<p class="portal-dev-inspector__field-label">Severity <span class="portal-dev-inspector__required">*</span></p>' +
      '<select class="portal-dev-inspector__select" data-role="note-severity">' +
      '<option value="">— seleziona —</option>' +
      '<option value="LOW">LOW</option>' +
      '<option value="MEDIUM">MEDIUM</option>' +
      '<option value="HIGH">HIGH</option>' +
      '<option value="CRITICAL">CRITICAL</option>' +
      '</select>' +
      '</div>' +

      '<div data-role="note-stato-wrap" hidden>' +
      '<p class="portal-dev-inspector__field-label">Stato</p>' +
      '<select class="portal-dev-inspector__select" data-role="note-stato">' +
      '<option value="">— non specificato —</option>' +
      '<option value="APERTO" selected>APERTO</option>' +
      '<option value="IN_VALUTAZIONE">IN_VALUTAZIONE</option>' +
      '<option value="CHIUSO">CHIUSO</option>' +
      '</select>' +
      '</div>' +

      '<p class="portal-dev-inspector__field-label">Riferimenti (decision log, ticket, link)</p>' +
      '<input class="portal-dev-inspector__input" data-role="note-riferimenti" type="text" placeholder="es. UX42, #123, slack thread" />' +

      '</div>' +

      '<p class="portal-dev-inspector__field-label portal-dev-inspector__field-label--section">Screenshot (opzionale)</p>' +
      '<div class="portal-dev-inspector__shot-row">' +
      '<button type="button" class="portal-dev-inspector__shot-btn" data-role="screenshot">📷 Scatta screenshot</button>' +
      '<button type="button" class="portal-dev-inspector__shot-btn portal-dev-inspector__shot-btn--clear" data-role="screenshot-clear" hidden>Rimuovi</button>' +
      '</div>' +
      '<p class="portal-dev-inspector__shot-status" data-role="screenshot-status"></p>' +
      '<img class="portal-dev-inspector__shot-preview" data-role="screenshot-preview" alt="Anteprima screenshot" hidden />' +

      '<div class="portal-dev-inspector__actions">' +
      '<button type="button" class="portal-dev-inspector__save" data-role="save">Salva Request</button>' +
      '<p class="portal-dev-inspector__save-status" data-role="save-status"></p>' +
      '</div>' +
      '</div>' +
      '<p class="portal-dev-inspector__hint">Click in pagina per bloccare la selezione. Nuovo click fuori dal pannello per cambiare nodo.</p>' +
      "</div>";

    document.body.appendChild(panel);
    state.panel = panel;
    state.statusNode = panel.querySelector('[data-role="status"]');
    state.elementNode = panel.querySelector('[data-role="element"]');
    state.routeNode = panel.querySelector('[data-role="route"]');
    state.componentListNode = panel.querySelector('[data-role="components"]');
    state.componentWarningNode = panel.querySelector('[data-role="component-warning"]');
    state.cssListNode = panel.querySelector('[data-role="css"]');
    state.titleNode = panel.querySelector('[data-role="title"]');
    state.changeTypeNode = panel.querySelector('[data-role="change-type"]');
    state.targetComponentNode = panel.querySelector('[data-role="target-component"]');
    state.targetComponentNode.addEventListener("change", function () {
      if (state.titleNode && state.targetComponentNode.value) {
        var name = state.targetComponentNode.options[state.targetComponentNode.selectedIndex].dataset.name || "";
        var current = state.titleNode.value.trim();
        if (!current || current.endsWith(" - modifica visuale")) {
          state.titleNode.value = (name || "UI") + " - modifica visuale";
        }
      }
    });
    state.requestNode = panel.querySelector('[data-role="request"]');
    state.currentStateNode = panel.querySelector('[data-role="current-state"]');
    state.targetStateNode = panel.querySelector('[data-role="target-state"]');
    state.invariantsNode = panel.querySelector('[data-role="invariants"]');
    state.constraintsNode = panel.querySelector('[data-role="constraints"]');
    state.referencesNode = panel.querySelector('[data-role="references"]');
    state.acceptanceVisualNode = panel.querySelector('[data-role="acceptance-visual"]');
    state.acceptanceBehaviorNode = panel.querySelector('[data-role="acceptance-behavior"]');
    state.acceptanceRejectNode = panel.querySelector('[data-role="acceptance-reject"]');
    state.saveButtonNode = panel.querySelector('[data-role="save"]');
    state.saveStatusNode = panel.querySelector('[data-role="save-status"]');
    state.screenshotButtonNode = panel.querySelector('[data-role="screenshot"]');
    state.screenshotClearButtonNode = panel.querySelector('[data-role="screenshot-clear"]');
    state.screenshotStatusNode = panel.querySelector('[data-role="screenshot-status"]');
    state.screenshotPreviewNode = panel.querySelector('[data-role="screenshot-preview"]');

    state.noteTipoNode = panel.querySelector('[data-role="note-tipo"]');
    state.noteTitoloNode = panel.querySelector('[data-role="note-titolo"]');
    state.noteContenutoNode = panel.querySelector('[data-role="note-contenuto"]');
    state.noteTagNode = panel.querySelector('[data-role="note-tag"]');
    state.noteSeverityNode = panel.querySelector('[data-role="note-severity"]');
    state.noteStatoNode = panel.querySelector('[data-role="note-stato"]');
    state.noteRiferimentiNode = panel.querySelector('[data-role="note-riferimenti"]');
    state.noteSeverityWrapNode = panel.querySelector('[data-role="note-severity-wrap"]');
    state.noteStatoWrapNode = panel.querySelector('[data-role="note-stato-wrap"]');

    if (state.noteTipoNode) {
      state.noteTipoNode.addEventListener("change", onNoteTipoChange);
    }

    var tabButtons = panel.querySelectorAll('[data-tab-btn]');
    for (var ti = 0; ti < tabButtons.length; ti++) {
      tabButtons[ti].addEventListener("click", function (event) {
        var name = event.currentTarget.getAttribute("data-tab-btn");
        if (name) { selectTab(name); }
      });
    }

    var savedTab = "modifica";
    try {
      var stored = localStorage.getItem("portal-dev-inspector-active-tab");
      if (stored === "modifica" || stored === "appunto") { savedTab = stored; }
    } catch (e) { /* localStorage not available */ }
    selectTab(savedTab);

    if (state.saveButtonNode) {
      state.saveButtonNode.addEventListener("click", function () {
        captureSubmit();
      });
    }

    if (state.screenshotButtonNode) {
      state.screenshotButtonNode.addEventListener("click", function () {
        captureScreenshot();
      });
    }

    if (state.screenshotClearButtonNode) {
      state.screenshotClearButtonNode.addEventListener("click", function () {
        clearScreenshot();
      });
    }

    var dragHandle = panel.querySelector('[data-role="drag-handle"]');
    if (dragHandle) {
      dragHandle.addEventListener("mousedown", onPanelDragStart);
    }
  }

  function onPanelDragStart(event) {
    if (event.button !== 0 || !state.panel) {
      return;
    }

    var rect = state.panel.getBoundingClientRect();
    state.isDragging = true;
    state.dragOffsetX = event.clientX - rect.left;
    state.dragOffsetY = event.clientY - rect.top;

    state.panel.style.left = rect.left + "px";
    state.panel.style.top = rect.top + "px";
    state.panel.style.right = "auto";
    state.panel.style.bottom = "auto";
    state.panel.setAttribute("data-dragging", "true");

    document.addEventListener("mousemove", onPanelDragMove, true);
    document.addEventListener("mouseup", onPanelDragEnd, true);

    event.preventDefault();
    event.stopPropagation();
  }

  function onPanelDragMove(event) {
    if (!state.isDragging || !state.panel) {
      return;
    }

    var rect = state.panel.getBoundingClientRect();
    var maxLeft = Math.max(window.innerWidth - rect.width, 0);
    var maxTop = Math.max(window.innerHeight - rect.height, 0);
    var left = Math.min(Math.max(event.clientX - state.dragOffsetX, 0), maxLeft);
    var top = Math.min(Math.max(event.clientY - state.dragOffsetY, 0), maxTop);

    state.panel.style.left = left + "px";
    state.panel.style.top = top + "px";

    event.preventDefault();
    event.stopPropagation();
  }

  function onPanelDragEnd(event) {
    if (!state.isDragging) {
      return;
    }

    state.isDragging = false;
    if (state.panel) {
      state.panel.removeAttribute("data-dragging");
    }
    document.removeEventListener("mousemove", onPanelDragMove, true);
    document.removeEventListener("mouseup", onPanelDragEnd, true);

    if (event) {
      event.preventDefault();
      event.stopPropagation();
    }
  }

  function onKeyDown(event) {
    if (event.ctrlKey && event.altKey && event.key && event.key.toLowerCase() === "d") {
      event.preventDefault();
      toggle();
      return;
    }

    if (event.ctrlKey && event.altKey && event.key && event.key.toLowerCase() === "s") {
      event.preventDefault();
      captureSubmit();
      return;
    }

    if (!state.enabled) {
      return;
    }

    if (event.key === "Escape") {
      event.preventDefault();
      if (state.locked) {
        state.locked = false;
        state.selectedElement = null;
        renderPanel();
      } else {
        disable();
      }
    }
  }

  function onMouseMove(event) {
    if (!state.enabled || state.locked || state.isDragging) {
      return;
    }

    var target = getInspectableTarget(event.target);
    if (!target) {
      return;
    }

    state.hoverElement = target;
    drawHighlight(target);
    renderPanel();
  }

  function onClick(event) {
    if (!state.enabled) {
      return;
    }

    var target = getInspectableTarget(event.target);
    if (!target) {
      return;
    }

    event.preventDefault();
    event.stopPropagation();

    state.locked = true;
    state.selectedElement = target;
    drawHighlight(target);
    renderPanel();
  }

  function onScroll() {
    if (!state.enabled) {
      return;
    }

    var element = getCurrentElement();
    if (element) {
      drawHighlight(element);
    }
  }

  function onResize() {
    if (!state.enabled) {
      return;
    }

    var element = getCurrentElement();
    if (element) {
      drawHighlight(element);
    }
  }

  function getInspectableTarget(target) {
    if (!(target instanceof Element)) {
      return null;
    }

    var ignoredContainer = target.closest("[data-dev-inspector-ui='true']");
    if (ignoredContainer) {
      return null;
    }

    return target;
  }

  function getCurrentElement() {
    return state.locked ? state.selectedElement : state.hoverElement;
  }

  function drawHighlight(element) {
    if (!element || !state.overlay) {
      return;
    }

    var rect = element.getBoundingClientRect();
    state.overlay.style.display = "block";
    state.overlay.style.top = rect.top + "px";
    state.overlay.style.left = rect.left + "px";
    state.overlay.style.width = rect.width + "px";
    state.overlay.style.height = rect.height + "px";
  }

  function hideHighlight() {
    if (!state.overlay) {
      return;
    }

    state.overlay.style.display = "none";
  }

  function enable() {
    init();
    state.enabled = true;
    state.locked = false;
    state.selectedElement = null;
    state.hoverElement = null;
    if (state.panel) {
      state.panel.setAttribute("data-open", "true");
    }
    renderPanel();
  }

  function disable() {
    state.enabled = false;
    state.locked = false;
    state.selectedElement = null;
    state.hoverElement = null;
    hideHighlight();
    if (state.panel) {
      state.panel.setAttribute("data-open", "false");
    }
  }

  function toggle() {
    if (state.enabled) {
      disable();
    } else {
      enable();
    }
  }

  function renderPanel() {
    if (!state.panel || !state.enabled) {
      return;
    }

    var active = getCurrentElement();

    state.statusNode.textContent = state.locked
      ? "Selezione bloccata (ESC per sbloccare)"
      : "Selezione live (muovi il mouse e clicca per bloccare)";
    state.elementNode.textContent = active ? formatElement(active) : "(nessun elemento selezionato)";
    state.routeNode.textContent = window.location.pathname + window.location.search;

    var componentChain = active ? getComponentChain(active) : [];
    renderList(
      state.componentListNode,
      componentChain,
      function (item) {
        return item.source ? item.name + " [" + item.source + "]" : item.name;
      },
      "Nessun tag data-dev-component trovato nella catena del DOM."
    );

    if (state.componentWarningNode) {
      var warningMsg = "";
      var warningState = "";

      if (active && componentChain.length === 0) {
        warningMsg = "Nessun componente identificato. Clicca dentro un'area annotata o seleziona un elemento più interno.";
        warningState = "error";
      } else if (active && componentChain.length > 0) {
        var lastNonShell = -1;
        for (var ck = 0; ck < componentChain.length; ck++) {
          var it = componentChain[ck];
          var combo = (it.name || "") + " " + (it.source || "");
          if (!/MainLayout|AreaSidebar/i.test(combo)) {
            lastNonShell = ck;
            break;
          }
        }
        if (lastNonShell === -1) {
          warningMsg = "Componente identificato troppo generico (solo shell: MainLayout/AreaSidebar). La pagina specifica non è stata annotata o l'elemento cliccato è fuori dal suo subtree DOM.";
          warningState = "warn";
        }
      }

      if (warningMsg) {
        state.componentWarningNode.textContent = warningMsg;
        state.componentWarningNode.setAttribute("data-state", warningState);
        state.componentWarningNode.hidden = false;
      } else {
        state.componentWarningNode.hidden = true;
        state.componentWarningNode.removeAttribute("data-state");
        state.componentWarningNode.textContent = "";
      }
    }

    var cssMatches = active ? getCssMatches(active, 80) : [];
    renderList(
      state.cssListNode,
      cssMatches,
      function (item) {
        return item.selector + " [" + item.source + "]";
      },
      "Nessuna regola CSS matchata."
    );

    // Ricostruisce le opzioni del select componente sorgente ad ogni cambio elemento
    if (state.targetComponentNode) {
      var previousValue = state.targetComponentNode.value;
      state.targetComponentNode.innerHTML = "";
      var emptyOpt = document.createElement("option");
      emptyOpt.value = "";
      emptyOpt.textContent = active ? "— seleziona componente —" : "— seleziona elemento prima —";
      state.targetComponentNode.appendChild(emptyOpt);

      var seen = new Set();
      for (var ci = 0; ci < componentChain.length; ci++) {
        var comp = componentChain[ci];
        if (!comp.source || seen.has(comp.source)) { continue; }
        seen.add(comp.source);
        var opt = document.createElement("option");
        opt.value = comp.source;
        opt.dataset.name = comp.name;
        opt.textContent = comp.name + "  ·  " + comp.source;
        if (ci === 0) { opt.selected = true; }
        state.targetComponentNode.appendChild(opt);
      }

      // Ripristina selezione precedente se ancora disponibile, altrimenti primo nodo
      if (previousValue && seen.has(previousValue)) {
        state.targetComponentNode.value = previousValue;
      }
    }

    // Aggiorna il titolo solo se non è stato modificato manualmente
    if (active && state.titleNode) {
      var selectedName = state.targetComponentNode && state.targetComponentNode.selectedIndex > 0
        ? (state.targetComponentNode.options[state.targetComponentNode.selectedIndex].dataset.name || "")
        : (componentChain.length > 0 ? componentChain[0].name : "UI");
      var currentTitle = state.titleNode.value.trim();
      if (!currentTitle || currentTitle.endsWith(" - modifica visuale")) {
        state.titleNode.value = selectedName + " - modifica visuale";
      }
    }
  }

  function renderList(listNode, items, projector, emptyText) {
    listNode.innerHTML = "";
    if (!items.length) {
      var li = document.createElement("li");
      li.textContent = emptyText;
      listNode.appendChild(li);
      return;
    }

    for (var i = 0; i < items.length; i += 1) {
      var itemNode = document.createElement("li");
      itemNode.textContent = projector(items[i]);
      listNode.appendChild(itemNode);
    }
  }

  function getComponentChain(element) {
    var chain = [];
    var cursor = element;
    while (cursor && cursor !== document.documentElement) {
      if (cursor.dataset && cursor.dataset.devComponent) {
        chain.push({
          name: cursor.dataset.devComponent,
          source: cursor.dataset.devSource || ""
        });
      }
      cursor = cursor.parentElement;
    }
    return chain;
  }

  function formatElement(element) {
    var tag = element.tagName.toLowerCase();
    var identifier = tag;
    if (element.id) {
      identifier += "#" + element.id;
    }
    if (element.classList && element.classList.length > 0) {
      identifier += "." + Array.from(element.classList).slice(0, 4).join(".");
    }
    return identifier;
  }

  function setSaveStatus(message, stateName) {
    if (!state.saveStatusNode) {
      return;
    }

    state.saveStatusNode.textContent = message;
    state.saveStatusNode.setAttribute("data-state", stateName || "info");
  }

  function setSaveBusy(isBusy) {
    if (!state.saveButtonNode) {
      return;
    }

    state.saveButtonNode.disabled = isBusy;
    var idleLabel = state.activeTab === "appunto" ? "Salva Appunto" : "Salva Request";
    state.saveButtonNode.textContent = isBusy ? "Salvataggio..." : idleLabel;
  }

  function getDomPath(element) {
    var path = [];
    var cursor = element;
    while (cursor && cursor.nodeType === Node.ELEMENT_NODE && cursor !== document.body) {
      var segment = cursor.tagName.toLowerCase();
      if (cursor.id) {
        segment += "#" + cursor.id;
        path.unshift(segment);
        break;
      }

      var sibling = cursor;
      var index = 1;
      while ((sibling = sibling.previousElementSibling)) {
        if (sibling.tagName === cursor.tagName) {
          index += 1;
        }
      }
      segment += ":nth-of-type(" + index + ")";
      path.unshift(segment);
      cursor = cursor.parentElement;
    }

    return path.join(" > ");
  }

  function buildPayload(element) {
    var rect = element.getBoundingClientRect();
    var attributes = Array.from(element.attributes || [])
      .slice(0, 60)
      .map(function (a) {
        return { name: a.name, value: a.value };
      });

    var textPreview = (element.innerText || element.textContent || "").replace(/\s+/g, " ").trim();
    if (textPreview.length > 260) {
      textPreview = textPreview.slice(0, 260) + "...";
    }

    return {
      title: state.titleNode ? state.titleNode.value.trim() : "",
      changeType: state.changeTypeNode ? state.changeTypeNode.value : "",
      targetComponent: state.targetComponentNode ? state.targetComponentNode.value.trim() : "",
      userRequest: state.requestNode ? state.requestNode.value.trim() : "",
      currentState: state.currentStateNode ? state.currentStateNode.value.trim() : "",
      targetState: state.targetStateNode ? state.targetStateNode.value.trim() : "",
      invariants: state.invariantsNode ? state.invariantsNode.value.trim() : "",
      constraints: state.constraintsNode ? state.constraintsNode.value.trim() : "",
      references: state.referencesNode ? state.referencesNode.value.trim() : "",
      acceptanceCriteria: {
        visual: state.acceptanceVisualNode ? state.acceptanceVisualNode.value.trim() : "",
        behavior: state.acceptanceBehaviorNode ? state.acceptanceBehaviorNode.value.trim() : "",
        reject: state.acceptanceRejectNode ? state.acceptanceRejectNode.value.trim() : ""
      },
      route: window.location.pathname + window.location.search,
      viewport: {
        width: window.innerWidth,
        height: window.innerHeight,
        pixelRatio: window.devicePixelRatio || 1
      },
      element: {
        tagName: element.tagName.toLowerCase(),
        id: element.id || "",
        className: element.className || "",
        textPreview: textPreview,
        domPath: getDomPath(element),
        bounds: {
          x: Number(rect.left.toFixed(2)),
          y: Number(rect.top.toFixed(2)),
          width: Number(rect.width.toFixed(2)),
          height: Number(rect.height.toFixed(2))
        },
        attributes: attributes
      },
      componentChain: getComponentChain(element),
      cssMatches: getCssMatches(element, 120)
    };
  }

  function setShotStatus(message, stateName) {
    if (!state.screenshotStatusNode) {
      return;
    }
    state.screenshotStatusNode.textContent = message || "";
    state.screenshotStatusNode.setAttribute("data-state", stateName || "info");
  }

  function setShotBusy(isBusy) {
    if (!state.screenshotButtonNode) {
      return;
    }
    state.screenshotButtonNode.disabled = isBusy;
    state.screenshotButtonNode.textContent = isBusy ? "Cattura in corso..." : "📷 Scatta screenshot";
  }

  function setScreenshot(blob) {
    if (state.screenshotPreviewNode && state.screenshotPreviewNode.src) {
      try { URL.revokeObjectURL(state.screenshotPreviewNode.src); } catch (e) { /* noop */ }
    }
    state.screenshotBlob = blob || null;
    if (state.screenshotPreviewNode) {
      if (blob) {
        state.screenshotPreviewNode.src = URL.createObjectURL(blob);
        state.screenshotPreviewNode.hidden = false;
      } else {
        state.screenshotPreviewNode.removeAttribute("src");
        state.screenshotPreviewNode.hidden = true;
      }
    }
    if (state.screenshotClearButtonNode) {
      state.screenshotClearButtonNode.hidden = !blob;
    }
  }

  function clearScreenshot() {
    setScreenshot(null);
    setShotStatus("", "info");
  }

  async function captureScreenshot() {
    if (!state.enabled) {
      setShotStatus("Inspector non attivo. Usa " + toggleHotkeyLabel + ".", "warn");
      return;
    }

    var active = getCurrentElement();
    if (!active) {
      setShotStatus("Seleziona prima un elemento.", "warn");
      return;
    }

    if (!navigator.mediaDevices || !navigator.mediaDevices.getDisplayMedia) {
      setShotStatus("getDisplayMedia non supportato da questo browser.", "error");
      return;
    }

    setShotStatus("Richiesta permesso al browser (seleziona 'Questa scheda')...", "info");
    setShotBusy(true);

    var stream = null;
    try {
      stream = await navigator.mediaDevices.getDisplayMedia({
        video: { displaySurface: "browser" },
        preferCurrentTab: true,
        selfBrowserSurface: "include",
        surfaceSwitching: "exclude",
        audio: false
      });
    } catch (e) {
      setShotStatus("Permesso negato o cattura annullata.", "error");
      setShotBusy(false);
      return;
    }

    var prevPanelVisibility = state.panel ? state.panel.style.visibility : "";
    if (state.panel) { state.panel.style.visibility = "hidden"; }
    hideHighlight();

    try {
      var video = document.createElement("video");
      video.srcObject = stream;
      video.muted = true;
      video.playsInline = true;
      await video.play();

      // Aspetta due frame perché il pannello sparisca dal render prima della cattura
      await new Promise(function (r) { requestAnimationFrame(function () { requestAnimationFrame(r); }); });

      var track = stream.getVideoTracks()[0];
      var settings = track.getSettings ? track.getSettings() : {};
      var captureW = settings.width || video.videoWidth || window.innerWidth;
      var captureH = settings.height || video.videoHeight || window.innerHeight;
      var scaleX = captureW / window.innerWidth;
      var scaleY = captureH / window.innerHeight;

      var rect = active.getBoundingClientRect();
      var sx = Math.max(0, Math.round(rect.left * scaleX));
      var sy = Math.max(0, Math.round(rect.top * scaleY));
      var sw = Math.max(1, Math.min(Math.round(rect.width * scaleX), captureW - sx));
      var sh = Math.max(1, Math.min(Math.round(rect.height * scaleY), captureH - sy));

      var canvas = document.createElement("canvas");
      canvas.width = sw;
      canvas.height = sh;
      var ctx = canvas.getContext("2d");
      ctx.drawImage(video, sx, sy, sw, sh, 0, 0, sw, sh);

      var blob = await new Promise(function (resolve) {
        canvas.toBlob(resolve, "image/png");
      });

      if (!blob) {
        setShotStatus("Conversione PNG fallita.", "error");
        return;
      }

      setScreenshot(blob);
      setShotStatus("Screenshot pronto · " + sw + "×" + sh + " px · " + Math.round(blob.size / 1024) + " KB", "success");
    } catch (e) {
      setShotStatus("Errore cattura: " + (e && e.message ? e.message : String(e)), "error");
    } finally {
      if (state.panel) { state.panel.style.visibility = prevPanelVisibility || ""; }
      if (stream) { stream.getTracks().forEach(function (t) { t.stop(); }); }
      setShotBusy(false);
    }
  }

  function selectTab(tabName) {
    if (tabName !== "modifica" && tabName !== "appunto") { return; }
    state.activeTab = tabName;
    try { localStorage.setItem("portal-dev-inspector-active-tab", tabName); } catch (e) { /* noop */ }

    if (!state.panel) { return; }

    var btns = state.panel.querySelectorAll("[data-tab-btn]");
    for (var i = 0; i < btns.length; i++) {
      btns[i].setAttribute("data-active", btns[i].getAttribute("data-tab-btn") === tabName ? "true" : "false");
    }

    var panels = state.panel.querySelectorAll("[data-tab-panel]");
    for (var j = 0; j < panels.length; j++) {
      panels[j].hidden = panels[j].getAttribute("data-tab-panel") !== tabName;
    }

    if (state.saveButtonNode) {
      state.saveButtonNode.textContent = tabName === "appunto" ? "Salva Appunto" : "Salva Request";
    }
  }

  function onNoteTipoChange() {
    var tipo = state.noteTipoNode ? state.noteTipoNode.value : "";

    if (state.noteSeverityWrapNode) {
      state.noteSeverityWrapNode.hidden = tipo !== "BUG_TODO";
    }
    if (state.noteStatoWrapNode) {
      state.noteStatoWrapNode.hidden = !(tipo === "BUG_TODO" || tipo === "DOMANDA");
    }

    if (state.noteContenutoNode) {
      var template = NOTE_CONTENT_TEMPLATES[tipo];
      if (template) {
        state.noteContenutoNode.placeholder = template;
        if (!state.noteContenutoNode.value.trim()) {
          state.noteContenutoNode.value = template;
        }
      } else {
        state.noteContenutoNode.placeholder = "Seleziona prima il tipo per vedere il template guidato.";
      }
    }
  }

  function captureSubmit() {
    if (state.activeTab === "appunto") {
      captureNote();
    } else {
      captureRequest();
    }
  }

  async function captureNote() {
    if (!state.enabled) {
      setSaveStatus("Inspector non attivo. Usa " + toggleHotkeyLabel + ".", "warn");
      return;
    }

    var tipo = state.noteTipoNode ? state.noteTipoNode.value : "";
    if (!tipo) {
      setSaveStatus("Seleziona il tipo di appunto.", "warn");
      state.noteTipoNode && state.noteTipoNode.focus();
      return;
    }

    var titolo = state.noteTitoloNode ? state.noteTitoloNode.value.trim() : "";
    if (!titolo) {
      setSaveStatus("Compila il titolo dell'appunto.", "warn");
      state.noteTitoloNode && state.noteTitoloNode.focus();
      return;
    }

    var contenuto = state.noteContenutoNode ? state.noteContenutoNode.value.trim() : "";
    if (!contenuto) {
      setSaveStatus("Compila il contenuto dell'appunto.", "warn");
      state.noteContenutoNode && state.noteContenutoNode.focus();
      return;
    }

    var severity = state.noteSeverityNode ? state.noteSeverityNode.value : "";
    if (tipo === "BUG_TODO" && !severity) {
      setSaveStatus("Per un BUG_TODO la severity è obbligatoria.", "warn");
      state.noteSeverityNode && state.noteSeverityNode.focus();
      return;
    }

    setSaveBusy(true);
    setSaveStatus("Salvataggio appunto in corso...", "info");

    var active = getCurrentElement();
    var componentChain = active ? getComponentChain(active) : [];
    var componente = "";
    if (state.targetComponentNode && state.targetComponentNode.value) {
      componente = state.targetComponentNode.value;
    } else if (componentChain.length > 0) {
      componente = componentChain[0].source || componentChain[0].name;
    }

    var notePayload = {
      tipo: tipo,
      titolo: titolo,
      contenuto: contenuto,
      tag: state.noteTagNode ? state.noteTagNode.value.trim() : "",
      severity: severity,
      stato: state.noteStatoNode ? state.noteStatoNode.value : "",
      riferimenti: state.noteRiferimentiNode ? state.noteRiferimentiNode.value.trim() : "",
      componente: componente,
      route: window.location.pathname + window.location.search,
      viewport: {
        width: window.innerWidth,
        height: window.innerHeight,
        pixelRatio: window.devicePixelRatio || 1
      },
      componentChain: componentChain
    };

    var formData = new FormData();
    formData.append("payload", JSON.stringify(notePayload));
    if (state.screenshotBlob) {
      formData.append("screenshot", state.screenshotBlob, "screenshot.png");
    }

    try {
      var response = await fetch("/dev/inspector-notes", {
        method: "POST",
        body: formData
      });

      var result = null;
      try { result = await response.json(); } catch (e) { result = null; }

      if (!response.ok) {
        var message = result && result.error ? result.error : "Errore salvataggio appunto.";
        setSaveStatus(message, "error");
        return;
      }

      var savedMsg = "Appunto salvato: " + (result.relativePath || result.fileName || "file creato");
      if (result && result.screenshot) {
        savedMsg += " · screenshot: " + result.screenshot;
      }
      setSaveStatus(savedMsg, "success");

      // Reset campi appunto e screenshot dopo successo
      if (state.noteTitoloNode) { state.noteTitoloNode.value = ""; }
      if (state.noteContenutoNode) { state.noteContenutoNode.value = ""; }
      if (state.noteTagNode) { state.noteTagNode.value = ""; }
      if (state.noteRiferimentiNode) { state.noteRiferimentiNode.value = ""; }
      clearScreenshot();
    } catch (error) {
      setSaveStatus("Errore rete durante il salvataggio dell'appunto.", "error");
    } finally {
      setSaveBusy(false);
    }
  }

  async function captureRequest() {
    if (!state.enabled) {
      setSaveStatus("Inspector non attivo. Usa " + toggleHotkeyLabel + ".", "warn");
      return;
    }

    var active = getCurrentElement();
    if (!active) {
      setSaveStatus("Seleziona prima un elemento.", "warn");
      return;
    }

    if (!state.requestNode || !state.requestNode.value.trim()) {
      setSaveStatus("Compila il campo 'Modifica richiesta' prima del salvataggio.", "warn");
      state.requestNode && state.requestNode.focus();
      return;
    }

    if (!state.changeTypeNode || !state.changeTypeNode.value) {
      setSaveStatus("Seleziona il tipo di modifica prima del salvataggio.", "warn");
      state.changeTypeNode && state.changeTypeNode.focus();
      return;
    }

    setSaveBusy(true);
    setSaveStatus("Invio richiesta in corso...", "info");

    var payload = buildPayload(active);
    var formData = new FormData();
    formData.append("payload", JSON.stringify(payload));
    if (state.screenshotBlob) {
      formData.append("screenshot", state.screenshotBlob, "screenshot.png");
    }

    try {
      var response = await fetch("/dev/ui-change-requests", {
        method: "POST",
        body: formData
      });

      var result = null;
      try {
        result = await response.json();
      } catch (e) {
        result = null;
      }

      if (!response.ok) {
        var message = result && result.error ? result.error : "Errore salvataggio richiesta.";
        setSaveStatus(message, "error");
        return;
      }

      var savedMsg = "Salvato: " + (result.relativePath || result.fileName || "file creato");
      if (result && result.screenshot) {
        savedMsg += " · screenshot: " + result.screenshot;
      }
      setSaveStatus(savedMsg, "success");
      clearScreenshot();
    } catch (error) {
      setSaveStatus("Errore rete durante il salvataggio.", "error");
    } finally {
      setSaveBusy(false);
    }
  }

  function getCssMatches(element, maxResults) {
    var matches = [];
    var unique = new Set();
    var styleSheets = document.styleSheets;
    for (var i = 0; i < styleSheets.length; i += 1) {
      var sheet = styleSheets[i];
      var source = normalizeSource(sheet.href);
      try {
        collectRules(sheet.cssRules, source, element, matches, unique, maxResults);
      } catch (error) {
        // Some stylesheets can be inaccessible due to browser constraints.
      }

      if (matches.length >= maxResults) {
        break;
      }
    }

    return matches;
  }

  function collectRules(rules, source, element, matches, unique, maxResults) {
    if (!rules) {
      return;
    }

    for (var i = 0; i < rules.length; i += 1) {
      if (matches.length >= maxResults) {
        return;
      }

      var rule = rules[i];
      if (rule.type === CSSRule.STYLE_RULE) {
        var selectors = rule.selectorText ? rule.selectorText.split(",") : [];
        for (var j = 0; j < selectors.length; j += 1) {
          if (matches.length >= maxResults) {
            return;
          }

          var selector = selectors[j].trim();
          if (!selector) {
            continue;
          }

          try {
            if (element.matches(selector)) {
              var key = selector + "::" + source;
              if (!unique.has(key)) {
                unique.add(key);
                matches.push({ selector: selector, source: source });
              }
            }
          } catch (error) {
            // Invalid selector for matches() in this browser context.
          }
        }
      } else if (rule.cssRules && rule.cssRules.length > 0) {
        collectRules(rule.cssRules, source, element, matches, unique, maxResults);
      }
    }
  }

  function normalizeSource(href) {
    if (!href) {
      return "inline";
    }

    try {
      var url = new URL(href, window.location.origin);
      return url.pathname.replace(/^\/+/, "");
    } catch (error) {
      return href;
    }
  }

  window.portalDevInspector = {
    init: init,
    enable: enable,
    disable: disable,
    toggle: toggle,
    capture: captureRequest
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
