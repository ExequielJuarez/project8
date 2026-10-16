// ==========================================================
// CATÁLOGO — Interacciones propias de la vista (usa base.js)
// Filtros (categoría/tipo, talle, color y precio), orden y panel de filtros.
// ==========================================================

document.addEventListener("DOMContentLoaded", () => {
  const { $, $$, abrirPanel, cerrarPaneles } = window.Tienda;

  const cuerpo = $(".catalogo__cuerpo");
  const filtros = $("#filtros");
  const grilla = $("#grilla");
  const tarjetas = $$(".tarjeta", grilla);
  const vacio = $("#vacio");
  const selectOrden = $("#orden");
  const rangoMin = $("#precioMin");
  const rangoMax = $("#precioMax");
  const chipsActivos = $("#chipsActivos");
  const badgeFiltros = $("#badgeFiltros");
  const cantidadVisible = $("#cantidadVisible");
  const campoGrupo = filtros.dataset.grupo || "categoria";
  const limiteMin = Number(rangoMin.min);
  const limiteMax = Number(rangoMin.max);
  const hayPanel = window.matchMedia("(min-width: 1100px)");

  // ---------- Panel de filtros ----------
  // En PC los filtros están a la izquierda y el botón los muestra u oculta;
  // en celular y tablet abre el panel lateral.
  const botonFiltros = $("#btnFiltros");
  botonFiltros.addEventListener("click", () => {
    if (hayPanel.matches) {
      const oculto = cuerpo.classList.toggle("sin-filtros");
      botonFiltros.setAttribute("aria-expanded", String(!oculto));
    } else {
      abrirPanel(filtros);
    }
  });
  $("#btnCerrarFiltros").addEventListener("click", cerrarPaneles);
  $("#btnAplicar").addEventListener("click", cerrarPaneles);

  // ---------- Precio ----------
  const formatoPrecio = (n) => "$ " + n.toLocaleString("es-AR", { maximumFractionDigits: 0 });

  // Los dos controles no se cruzan; el relleno marca el tramo elegido
  function pintarRango() {
    let min = Number(rangoMin.value);
    let max = Number(rangoMax.value);
    if (min > max) [min, max] = [max, min];
    const total = limiteMax - limiteMin || 1;
    const rellenoDesde = ((min - limiteMin) / total) * 100;
    const rellenoHasta = ((max - limiteMin) / total) * 100;
    const relleno = $("#rangoRelleno");
    relleno.style.left = `${rellenoDesde}%`;
    relleno.style.right = `${100 - rellenoHasta}%`;
    $("#precioMinTexto").textContent = formatoPrecio(min);
    $("#precioMaxTexto").textContent = formatoPrecio(max);
    return { min, max };
  }

  // ---------- Filtrado ----------
  function leerFiltros() {
    const { min, max } = pintarRango();
    return {
      // Filtro propio de la página: subcategorías (sección) o categorías (resto)
      grupo: $$(`input[name="${campoGrupo}"]:checked`).map((i) => i.value),
      talles: $$('input[name="talle"]:checked').map((i) => i.value),
      colores: $$('input[name="color"]:checked').map((i) => i.value),
      min,
      max,
    };
  }

  function aplicarFiltros() {
    const f = leerFiltros();
    let visibles = 0;

    tarjetas.forEach((t) => {
      const precio = Number(t.dataset.precio);
      const pasa =
        (!f.grupo.length || f.grupo.includes(t.dataset[campoGrupo])) &&
        (!f.talles.length || (t.dataset.talles || "").split(",").some((x) => f.talles.includes(x))) &&
        (!f.colores.length || (t.dataset.colores || "").split(" ").some((c) => f.colores.includes(c))) &&
        precio >= f.min &&
        precio <= f.max;

      t.hidden = !pasa;
      if (pasa) visibles++;
    });

    vacio.hidden = visibles > 0;
    cantidadVisible.textContent = visibles;
    $("#cantidadPalabra").textContent = visibles === 1 ? "producto" : "productos";
    pintarChips(f);
    marcarSubnav(f);
  }

  // ---------- Accesos rápidos a las subcategorías (arriba del listado) ----------
  // Sin recargar: marcan el filtro de esa subcategoría y actualizan la dirección
  const linksSub = $$("[data-sub-link]");

  function marcarSubnav(f) {
    if (!linksSub.length) return;
    const unica = f.grupo.length === 1 ? f.grupo[0] : f.grupo.length ? null : "";
    linksSub.forEach((a) => a.classList.toggle("activo", a.dataset.subLink === unica));
    const url = new URL(window.location.href);
    if (unica) url.searchParams.set("sub", unica);
    else url.searchParams.delete("sub");
    history.replaceState(null, "", url);
  }

  linksSub.forEach((a) =>
    a.addEventListener("click", (e) => {
      e.preventDefault();
      $$(`input[name="${campoGrupo}"]`).forEach((i) => (i.checked = i.value === a.dataset.subLink));
      aplicarFiltros();
    })
  );

  function pintarChips(f) {
    const chips = [
      ...f.grupo.map((v) => ({
        tipo: campoGrupo,
        valor: v,
        texto: $(`input[name="${campoGrupo}"][value="${CSS.escape(v)}"]`)?.closest("label").querySelector(".check__texto").textContent || v,
      })),
      ...f.talles.map((v) => ({ tipo: "talle", valor: v, texto: `Talle ${v}` })),
      ...f.colores.map((v) => ({
        tipo: "color",
        valor: v,
        texto: $(`input[name="color"][value="${CSS.escape(v)}"]`)?.closest("label").title || v,
      })),
    ];
    if (f.min > limiteMin || f.max < limiteMax) {
      chips.push({ tipo: "precio", texto: `${formatoPrecio(f.min)} – ${formatoPrecio(f.max)}` });
    }

    chipsActivos.innerHTML = "";
    chips.forEach((c) => {
      const chip = document.createElement("button");
      chip.className = "chip";
      chip.textContent = `${c.texto} `;
      chip.insertAdjacentHTML("beforeend", '<span aria-hidden="true">✕</span>');
      chip.setAttribute("aria-label", `Quitar filtro ${c.texto}`);
      chip.addEventListener("click", () => {
        if (c.tipo === "precio") {
          rangoMin.value = limiteMin;
          rangoMax.value = limiteMax;
        } else {
          const input = $(`input[name="${c.tipo}"][value="${CSS.escape(c.valor)}"]`);
          if (input) input.checked = false;
        }
        aplicarFiltros();
      });
      chipsActivos.appendChild(chip);
    });

    badgeFiltros.hidden = chips.length === 0;
    badgeFiltros.textContent = chips.length;
  }

  function limpiarFiltros() {
    $$('.filtros input[type="checkbox"]').forEach((i) => (i.checked = false));
    rangoMin.value = limiteMin;
    rangoMax.value = limiteMax;
    aplicarFiltros();
  }

  $$('.filtros input[type="checkbox"]').forEach((i) => i.addEventListener("change", aplicarFiltros));
  [rangoMin, rangoMax].forEach((i) => i.addEventListener("input", aplicarFiltros));
  $("#btnLimpiar").addEventListener("click", limpiarFiltros);
  $$("[data-limpiar]").forEach((b) => b.addEventListener("click", limpiarFiltros));
  pintarRango();
  // Si se llegó con un filtro marcado (?sub=) ya hay que mostrarlo aplicado
  if ($$('.filtros input[type="checkbox"]:checked').length) aplicarFiltros();

  // ---------- Orden ----------
  selectOrden.addEventListener("change", () => {
    const criterio = selectOrden.value;
    const ordenadas = [...tarjetas].sort((a, b) => {
      switch (criterio) {
        case "precio-asc":
          return a.dataset.precio - b.dataset.precio;
        case "precio-desc":
          return b.dataset.precio - a.dataset.precio;
        case "nombre-asc":
          return a.dataset.nombre.localeCompare(b.dataset.nombre, "es");
        default:
          return a.dataset.orden - b.dataset.orden;
      }
    });
    ordenadas.forEach((t) => grilla.insertBefore(t, vacio));
  });
});
