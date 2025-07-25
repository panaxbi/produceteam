xo.spaces["expanded"] = "http://panax.io/state/expanded";
xo.spaces["visible"] = "http://panax.io/state/visible";
xo.spaces["hidden"] = "http://panax.io/state/hidden";

xo.listener.on('xover-initialized', function ({ progress_renders }) {
    if ('#loading' in xover.manifest.sources) {
        progress_renders.concat(xover.sources['#loading'].render());
    }
})

xover.listener.on('xover-initialized', function () {
    window.setInterval(function () {
        xover.session.checkStatus();
    }, 900000);
})

xo.listener.on('set::fecha/@state:checked', function ({ value, event }) {
    this.parentNode.select("//model/fechas/@state:current_date_er").remove()
    //if (!(event.target instanceof SVGElement)) {
    //    this.parentNode.select("parent::fechas/fecha/@state:checked").filter(attr => attr != this).removeAll();
    //}
    if (value == 'true') {
        let current_year = this.parentNode.getAttribute('mes').substring(0, 4);
        let expanded_array = xo.state.expanded;
        for (let [obj, expanded] of [...expanded_array || []]) {
            let config = JSON.parse(obj);
            let account_list = this.ownerDocument.select(`/model//cuenta[@id=${config.cta || "@id"}]/*/ancestor-or-self::cuenta[@n<=${isFinite(expanded) ? expanded : "@n"}]/@id`).map(n => n.value);
            let matches = this.selectFirst(`/model/*${Object.entries(config).filter(([key]) => key != 'cta').map(([key, value]) => `[@${key}="${value}"]`).join('')}/@fecha[starts-with(.,'${current_year}')]`);
            if (!matches) expanded_array.delete(obj);
        }
    }
}, true)

xo.listener.on('change::model/*/*/@state:checked[.="true"]', function ({ element, stylesheet, srcElement, value, old }) {
    let id = element.getAttributeNode("id") || element.getAttributeNode("mes")
    if (!(srcElement instanceof SVGElement)) {
        if (value) {
            element.select(`../${element.nodeName}[not(@${id.nodeName}="${id}")]/@state:checked`).remove()
        }
    }
})

xo.listener.on('change::razon_social/@state:checked[.="true"]|unidad_negocio/@state:checked[.="true"]', function ({ element, stylesheet, srcElement, value, old }) {
    element.select("@div").map(div => div.parentNode.select(`//model/divisiones/division[@id="${div.value}"][not(@state:checked)]`).set("state:checked", value))
})

xo.listener.on('change::divisiones/division/@state:checked', function ({ target, stylesheet, srcElement, value, old }) {
    let div = this.parentNode.selectFirst("@id");
    if (eval(old)) {
        div.parentNode.select(`//model/razones_sociales/razon_social[@div="${div}"]/@state:checked`).remove()
        div.parentNode.select(`//model/unidades_negocio/unidad_negocio/@state:checked`).remove()
    }
})

xo.listener.on(['replaceWith::[xo-stylesheet="page_controls.mantenibles.xslt"]'], ({ new_node, old }) => {
    if (!new_node.childNodes.length) {
        new_node.replaceChildren(...old.childNodes)
        //new_node.querySelectorAll("[xo-stylesheet]").toArray().concat([new_node].filter(el => el.matches("[xo-stylesheet]")))
    }
})

async function submit(node) {
    let progress = await xo.sources["loading.xslt"].render();
    if (node.filter('//security').pop()) {
        let response = await xo.server.applyPermissions(xo.xml.createDocument(node));
        response.render()
    } else {
        return Promise.reject("No implementado")
    }
    progress.remove();
}

xo.listener.on("mousedown", function (event) {
    if (!(event && event.buttons == 1 && (this.closest('.validation-enabled, .blacklist-enabled, .selection-enabled') && window.getComputedStyle(this).cursor == 'cell'))) return
    let parent_container = this.closest("table, tbody, .validation-enabled, .blacklist-enabled, .selection-enabled");
    if (!parent_container) return;
    let parent_cell = this.closest('.cell,td,th');
    if (parent_cell && parent_container && !(event && (event.ctrlKey || event.shiftKey))) {
        [...parent_container.querySelectorAll(".selected svg.bi-box-arrow-up-right")].filter(svg => !parent_cell.contains(svg)).forEach(svg => { svg.remove() });
        [...parent_container.querySelectorAll(".selected,.selection-begin,.selection-end,.top-selection,.bottom-selection,.left-selection,.right-selection")].forEach(cell => { cell.classList.remove("selected", "selection-begin", "selection-end", "top-selection", "bottom-selection", "left-selection", "right-selection") });
    }
    let cell = window.getComputedStyle(this).cursor == 'cell' && this || this.closest(".cell");
    if (cell) {
        if (event && (event.ctrlKey || event.shiftKey) && [...parent_cell.classList].some(el => ["selected", "selection-end", "selection-begin"].includes(el))) {
            parent_cell.classList.remove("selected", "selection-begin", "selection-end")
        } else {
            cell.classList.add("selected");
            cell.classList.add("selection-begin");
        }

        //console.log(event.target);
        event.stopPropagation();
        event.preventDefault();
        event.cancelBubble = true;
        event.returnValue = false;
    }
    xo.state.validate = !!(xo.state.validations || selection.cells.find(cell => cell.closest('.validation-enabled')));
    xo.state.blacklist = !!(xo.state.blacklist_items || selection.cells.find(cell => cell.closest('.blacklist-enabled')));
    this.closest(".cell") && selection.cells.length && selection.cells.showInfo();
})

xo.listener.on("mousemove::*[ancestor-or-self::*/@class[contains(.,'validation-') or contains(.,'selection-') or contains(.,'blacklist-')]]", async function (event) {
    if (this.closest(`dialog,menu,ul`) || !(event && event.buttons == 1 && (this.closest('.validation-enabled, .blacklist-enabled, .selection-enabled') || window.getComputedStyle(this).cursor == 'cell'))) return
    let parent_container = this.closest("table, tbody, .validation-enabled, .blacklist-enabled, .selection-enabled");
    if (parent_container) {
        let selection_started = parent_container.querySelector(".selection-begin");
        if (!selection_started) return;
        let selection_end = parent_container.querySelector(".selection-end");
        if (selection_end) return;
        //let classList = [...this.classList];
        //let classDomains = [...selection_started.classList].filter(cl => cl.indexOf("domain-") == 0);
        //if ((!classDomains.length || classDomains.every(cl => classList.includes(cl))) && parent_container.contains(selection_started) && !selection_end) {
        //    this.classList.add("selected");
        //}
        xo.state.validate = !!(xo.state.validations || selection.cells.find(cell => cell.closest('.validation-enabled')));
        xo.state.blacklist = !!(xo.state.blacklist_items || selection.cells.find(cell => cell.closest('.blacklist-enabled')));
        selectCells(selection_started, window.getComputedStyle(this).cursor == 'cell' && this || this.closest(".cell"));
        this.closest(".cell") && selection.cells.showInfo();
    }
})

xo.listener.on("mouseup", function (event) {
    if (this.closest(`dialog,menu,ul`) || !(this.closest('.validation-enabled, .blacklist-enabled, .selection-enabled') || window.getComputedStyle(this).cursor == 'cell')) return;
    if (this instanceof HTMLTableCellElement && this.matches(".cell") && !(this.matches(".presupuesto"))) {
        [...this.querySelectorAll("a.auxiliar-polizas")].removeAll();
        let cell = this;
        let attributes = cell.select("ancestor-or-self::*/@div[1]|ancestor-or-self::*/@rs[1]|ancestor-or-self::*/@un[1]|ancestor-or-self::*/@cta[1]|ancestor-or-self::*/@cl[1]|ancestor-or-self::*/@fecha[1]|ancestor-or-self::*/@tipo[1]").reduce((obj, attr) => { obj['@' + attr.name] = attr.value || ''; return obj }, {})
        if (attributes["@fecha"] != '' && (attributes["@fecha"] || '').indexOf('~') == -1 && (attributes["@cta"] || attributes["@cl"]) && attributes["@rs"]) {
            if (this.closest('.presupuestos')) attributes["@tipo"] = 'presupuesto'
            let url_params = new URLSearchParams(attributes);
            let div = document.createElement('div');
            div.innerHTML = (`<a class="auxiliar-polizas" href="#polizas?${decodeURIComponent(url_params.toString())}" style="text-decoration: none; color: currentColor; margin-left: 5pt;"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-box-arrow-up-right" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8.636 3.5a.5.5 0 0 0-.5-.5H1.5A1.5 1.5 0 0 0 0 4.5v10A1.5 1.5 0 0 0 1.5 16h10a1.5 1.5 0 0 0 1.5-1.5V7.864a.5.5 0 0 0-1 0V14.5a.5.5 0 0 1-.5.5h-10a.5.5 0 0 1-.5-.5v-10a.5.5 0 0 1 .5-.5h6.636a.5.5 0 0 0 .5-.5z"/><path fill-rule="evenodd" d="M16 .5a.5.5 0 0 0-.5-.5h-5a.5.5 0 0 0 0 1h3.793L6.146 9.146a.5.5 0 1 0 .708.708L15 1.707V5.5a.5.5 0 0 0 1 0v-5z"/></svg></a>`)
            let link = div.firstChild;
            cell.append(link);
        }
    }
    let parent_container = this.closest("table, tbody");
    if (parent_container) {
        let selection_started = parent_container.querySelector(".selection-begin");
        let cells = selection.cells;
        let offcanvas = this.closest(".cell") && document.querySelector('#offcanvasSelection');
        if (offcanvas) {
            offcanvas = new bootstrap.Offcanvas(offcanvas);
                offcanvas.show()
            if (!cells.length) {
                offcanvas.hide()
            }
        }
        if (selection_started) {
            let cell = window.getComputedStyle(this).cursor == 'cell' && this || this.closest(".cell");
            cell && cell.classList.add("selection-end");
            if (offcanvas) {
                //new bootstrap.Offcanvas(offcanvas).toggle()
                ////let rows = parent_container.querySelectorAll("tr:has(.cell.selected)"); // Esta parte del código tiene problemas de rendimiento con datasets grandes por recálculos en estilos
                ////for (let [r, row] of rows.entries()) {
                ////    if (r == 0) row.classList.add("top-selection");
                ////    if (r == rows.length - 1) row.classList.add("bottom-selection");
                ////    let cols = row.querySelectorAll(".cell.selected");
                ////    for (let [c, col] of cols.entries()) {
                ////        if (c == 0) col.classList.add("left-selection");
                ////        if (c == cols.length - 1) col.classList.add("right-selection");
                ////    }
                ////}
                xo.state.validate = !!(xo.state.validations || cells.find(cell => cell.closest('.validation-enabled')));
                xo.state.blacklist = !!(xo.state.blacklist_items || cells.find(cell => cell.closest('.blacklist-enabled')));
                cells.showInfo();
            }
        } else {
            cells.showInfo();
        }
    }
})

selectCells = function (selection_started, selection_end) {
    //xover.manager.delay.set(selection_started, xover.manager.delay.get(selection_started) || xover.delay(1).then(() => {
    if (!selection_end) selection_end = selection_started;
    selection_started
    let [ix, iy] = [selection_started.closest("td,th,tbody,table,body").cellIndex, selection_started.closest("tr,tbody,table,body").rowIndex];
    let [ex, ey] = [selection_end.closest("td,th,tbody,table,body").cellIndex, selection_end.closest("tr,tbody,table,body").rowIndex];

    if (ix > ex) [ix, ex] = [ex, ix];
    if (iy > ey) [iy, ey] = [ey, iy];

    let parent_container = selection_end.closest("tbody,table");
    let oy = parent_container.rows[0].rowIndex;
    iy = iy - oy;
    ey = ey - oy;
    let classDomains = [...selection_started.classList].filter(cl => cl.indexOf("domain-") == 0);
    parent_container && [...parent_container.querySelectorAll(".cell.selected")].forEach(cell => { cell.classList.remove("selected", "border-top", "border-right", "border-bottom", "border-left") });
    for (let r = iy; r <= ey; ++r) {
        for (let c = ix; c <= ex; ++c) {
            let row = parent_container.rows[r] || null;
            let target = row && row.cells[c] || null;
            if (!target) continue;
            let classList = target && [...target.classList];
            if ((!classDomains.length || classDomains.every(cl => classList.includes(cl))) && parent_container.contains(selection_started)) {
                target.classList.add("selected");
                //selection_end.classList.add("selection-end"); // Esta parte del código tiene problemas de rendimiento con datasets grandes por recálculos en estilos
                //target.classList[(c == ix) ? 'add' : 'remove']("border-left");
                //target.classList[(c == ex) ? 'add' : 'remove']("border-right");
                //target.classList[(r == iy) ? 'add' : 'remove']("border-top");
                //target.classList[(r == ey) ? 'add' : 'remove']("border-bottom");
            }
        }
    }
    //}).catch((e) => {
    //    return Promise.reject(e)
    //}).finally(async () => {
    //    xover.manager.delay.delete(selection_started);
    //}));
    //return xover.manager.delay.get(selection_started);
}

let selection = {};
Object.defineProperty(selection, 'cells', {
    get: function () {
        let result = [...document.querySelectorAll(".selected")];

        Object.defineProperty(result, 'showInfo', {
            value: function () {
                let selection = this;
                let target = document.forms['selection'];
                if (!target) return;

                let formatValue = function (node) {
                    let value;
                    if (!node) {
                        value = null;
                    } else if (['days'].includes(node.name)) {
                        value = new Intl.NumberFormat().format(node.value)
                    } else {
                        value = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(node.value)
                    }
                    return value;
                }
                let sum = selection.sum();
                //let map = selection.groupDimensions()
                let config = selection.every(el => el.classList.contains("money")) ? { style: 'currency', currency: 'USD' } : {};
                target.querySelector('.valor').classList.remove('d-none');
                target.valor.value = !isNaN(sum) ? new Intl.NumberFormat('en-US', config).format(sum) : sum;
                let detalle = target.querySelector('.detalle');
                if (detalle) {
                    detalle.classList.add('d-none')
                    if (isNaN(sum) && detalle && sum.match(/^\d{3}-\d{3}/)) {
                        detalle.classList.remove('d-none')
                        let link = detalle.querySelector('a')
                        let url = xover.URL(link.href);
                        let [tag, search = ''] = url.hash.split("?");
                        let searchParams = new URLSearchParams(search);
                        searchParams.set("@account", `'${sum}'`)
                        url.hash = tag + '?' + searchParams.toString()
                        link.href = url.href;
                    }
                }

                target.querySelector('.formula').classList.add('d-none');
                if (selection.length == 1) {
                    let el = selection[0];
                    let scope = el.scope;
                    let formula = el.getAttribute("formula");
                    if (formula) {
                        target.querySelector('.valor').classList.add('d-none');
                        target.querySelector('.formula').classList.remove('d-none');
                        target.querySelector('label').textContent = formula + ' = ';
                        if (scope) {
                            target.querySelector('code').innerHTML = formula.replace(/@[\w]+/g, (match) => `<var title="${match.substr(1)}">${formatValue(scope.getAttributeNode(match.substr(1)))}</var>`);
                        }
                    }
                }
            }, writable: false, configurable: false, enumerable: false
        })

        Object.defineProperty(result, 'sum', {
            value: function () {
                let concat = this.some(el => !el.closest('.money,.number'));
                let values = this.map((el, ix, array) => {
                    let dims = ["div", "rs", "un", "prod", "cta", "indicador", "cl", "fecha", "value"];
                    let cell = el.select(dims.map(dim => `ancestor-or-self::*/@${dim}[1]`).join("|")).filter(attr => attr.value).reduce((cell, attr) => { cell[attr.name] = attr.value || ''; return cell }, {});

                    if (!cell.hasOwnProperty("value")) {
                        let value = (el.querySelector("input") || el).value;
                        if (concat) {
                            cell["value"] = value;
                        } else {
                            cell["value"] = parseFloat(value.replace(/%|\$|,/g, '').replace(/\(/g, '-')) || 0;
                        }
                    }
                    return concat ? cell["value"] : parseFloat(cell["value"] || 0)
                })
                return concat ? (values).distinct().filter(value => value).join(", ") : values.reduce((sum, item) => sum + item, 0)
            }, writable: false, configurable: false, enumerable: false
        })

        Object.defineProperty(result, 'groupDimensions', {
            value: function (...dims) {
                dims = dims.length && dims || ["div", "rs", "un", "prod", "cta", "indicador", "cl", "fecha"];
                let map = { "*": {} };
                this.forEach(el => {
                    for (let attr of el.select(dims.map(dim => `ancestor-or-self::*/@${dim}[1]`).join("|"))) {
                        map[attr.name] = map[attr.name] || {};
                        let scope = el.scope;
                        if (scope.parentNode.nodeName == 'line' && (scope instanceof Attr || scope instanceof Text)) {
                            value = scope;
                        } else {
                            value = parseFloat(el.textContent.replace(/%|\$|,/g, '').replace(/\(/g, '-')) || 0;
                        }
                        let dim_value = map[attr.name];
                        dim_value[attr.value] = dim_value[attr.value] || new Set();
                        dim_value[attr.value].add(value);
                        map["*"][value.nodeName] = map["*"][value.nodeName] || new Set();
                        map["*"][value.nodeName].add(value);
                    }
                })
                return map;
            }, writable: false, configurable: false, enumerable: false
        })

        Object.defineProperty(result, 'fix', {
            value: function (valid) {
                let validations = xo.site.state.validations || [];
                let selection = this.map(el => {
                    el.classList.remove("valid", "invalid")
                    let cell = el.select("ancestor-or-self::*/@div[1]|ancestor-or-self::*/@rs[1]|ancestor-or-self::*/@un[1]|ancestor-or-self::*/@cta[1]|ancestor-or-self::*/@indicador[1]|ancestor-or-self::*/@cl[1]|ancestor-or-self::*/@fecha[1]|ancestor-or-self::*/@value[1]").filter(attr => attr.value).reduce((cell, attr) => { cell[attr.name] = attr.value || ''; return cell }, {});

                    let value;
                    if (!cell.hasOwnProperty("value")) {
                        cell["value"] = parseFloat(el.textContent.replace(/%|\$|,/g, '').replace(/\(/g, '-')) || 0;
                    }
                    if (valid) {
                        value = cell["value"];
                    } else {
                        value = prompt(`Cuál debe ser el valor para ${Object.entries(cell).reduce((values, [key, value]) => { values.push(`${key}:${value}`); return values }, []).join(', ')}`);
                    }
                    if (value != undefined) {
                        cell["value"] = parseFloat(cell["value"]).toFixed(4);
                        value = parseFloat(value).toFixed(4);
                        if (cell.fecha && (cell.cta || cell.indicador || cell.cl) && (cell.div || cell.rs)) {
                            if (value == cell["value"]) {
                                el.classList.add("valid")
                            } else {
                                el.classList.add("invalid")
                            }
                        }
                        cell["value"] = value;
                        return cell;
                    }
                }).filter(el => el);
                selection = validations.concat(selection.filter(obj => obj.fecha && (obj.cta || obj.cl || obj.indicador)));
                xo.site.state.validations = selection;
                xo.site.save();
            }, writable: false, configurable: false, enumerable: false
        })
        return result;
    }
});

xo.listener.on(`change::row/@*[not(contains(namespace-uri(),'http://panax.io/state') or contains(namespace-uri(),'http://panax.io/metadata'))]`, function ({ element: row, attribute, value, old }) {
    let initial_value = row.getAttributeNodeNS('http://panax.io/state/initial', attribute.nodeName.replace(':', '-'));
    if (!initial_value) {
        row.set(`initial:${attribute.nodeName.replace(':', '-')}`, old);
    } else if (value == initial_value.value) {
        initial_value.remove();
    }

    let initial_attributes = row.select("@initial:*");
    if (initial_attributes.some(el => el.value != el.parentNode.getAttribute(el.localName))) {
        row.set(`state:dirty`, 1);
    } else {
        row.removeAttribute(`state:dirty`)
    }
});

xo.listener.on('click::.selected.editable.selection-begin.selection-end', function () {
    let cell = this.closest(".selected.editable[xo-slot]");
    if (!cell) return;
    let scope = cell.scope;
    if (!(scope/* && scope.matches("@ppto")*/)) return;

    const content = cell.textContent;

    const input = document.createElement('input');
    const children = [...cell.childNodes];
    input.type = 'text';
    input.value = content.trim();

    try {
        cell.replaceChildren(input);
    } catch (e) {

    }

    input.focus();
    input.select();
    input.addEventListener('blur', function () {
        cell.replaceChildren(...children)
    });
    input.addEventListener('keydown', function () {
        if (event.keyCode == 13) {
            input.blur()
        }
    });
    input.addEventListener('input', function (event) {
        let [current_caret] = xover.dom.getCaretPosition(input);
        let value = input.value;

        let previous = value.substring(0, current_caret);
        //let separators = [...previous.matchAll(/[^\d.]/g)].length;
        let new_value = value.replace(/[^\d.]/g, '').replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        if (event.inputType === 'deleteContentForward' && new_value[current_caret] == ',') {
            active_caret = current_caret + 1
        } else if (event.inputType != 'deleteContentForward' && new_value[current_caret - 1] == ',') {
            active_caret = current_caret - 1
        } else if (event.inputType === 'insertText' && new_value[current_caret] != ',' && new_value[current_caret - 1] != ',' && new_value[current_caret - 2] != ',') {
            active_caret = previous.length + 1
        } else {
            active_caret = current_caret
        }
        //console.log({ previous, separators, new_value, current_caret, active_caret, value })

        input.value = new_value;
        xover.dom.setCaretPosition(input, [active_caret]);
        selection.cells.showInfo()
    });
    input.addEventListener('change', function () {
        scope.value = this.value;
    });
})
xo.listener.on(['append::dialog[open]'], function () {
    this.close()
    this.showModal()
})

xo.listener.on(`change::@state:date`, function ({ value, event }) {
    let srcElement = event.srcElement;
    let store = srcElement.store;
    if (!store) return;
    store.source.definition["server:request"]["@month"] = value;
    store.document.fetch();
})

xo.listener.on(`beforeTransform?stylesheet.href=ventas_por_fecha_embarque.xslt`, function ({ document }) {
    for (let attr of [...this.documentElement.attributes].filter(attr => attr.namespaceURI == 'http://panax.io/state/filter')) {
        this.select(`//ventas/row[${attr.value.split("|").map(value => `@${attr.localName}!="${value}"`).join(" and ")}]`).forEach(el => el.remove())
    }

    let amt = this.select(`//ventas/row/@amt`);
    let qtym = this.select(`//ventas/row/@qtym`);
    if (amt.length && qtym.length) {
        this.selectFirst(`//ventas`).setAttribute(`state:avg_upce`, amt.reduce(Sum, 0) / qtym.reduce(Sum, 0));
    }
    let tcos = this.select(`//ventas/row/@tcos`);
    let amt_ad = this.select(`//ventas/row/@amt_ad`);
    if (amt.length && qtym.length && tcos.length && amt_ad.length) {
        this.selectFirst(`//ventas`).setAttribute(`state:avg_pce`, (amt.reduce(Sum, 0) - tcos.reduce(Sum, 0) - amt_ad.reduce(Sum, 0)) / qtym.reduce(Sum, 0));
    }

})

xo.listener.on([`beforeTransform::model[*/@filter:*]`, `beforeTransform?stylesheet.href=auxiliar_cuentas.xslt`], function () {
    for (let attr of this.select(`//@filter:*`)) {
        this.select(`//movimientos/row[not(@xsi:type="mock")][${attr.value.split("|").map(value => `@${attr.localName}!="${value}"`).join(" and ")}]`).forEach(el => el.remove())
    }
})

xo.listener.on(`beforeTransform?stylesheet.href*=liquidacion_detalle::model`, function ({ document, stylesheet }) {
    let distinct_attrs = document.select(`//ventas/*/@*`).map(attr => attr.name).distinct();
    for (let attr of this.select(`//ventas/@*[not(namespace-uri())]`).filter(attr => !distinct_attrs.includes(attr.name))) {
        attr.remove()
    }
})

xo.listener.on("fetch::xo:response", function () {
    let new_node = this.selectFirst('xo:response//model');
    new_node instanceof Element && this.documentElement.replaceWith(new_node)
})

xo.listener.on('beforeRender::html:dialog', function ({ element }) {
    if ([...document.querySelectorAll('dialog')].find(dialog => dialog.isEqualNode(element))) {
        event.preventDefault()
    }
})

xo.listener.skipSelector(".dropdown-menu.show")

mostrarGrafica = function () {
    let chart = document.getElementById('myChart');
    let offcanvas = chart.closest('.offcanvas');
    offcanvas && bootstrap.Offcanvas.getOrCreateInstance(offcanvas).show()
}

createCommand = function (params = {}) {
    return Object.entries(params).filter(entry => entry[0][0] != '^').map(([field, value], ix) => field == 'command' ? `EXEC ${value} ` : `${(ix > 1 ? ', ' : '') + field}='${value}'`).join('')
}

xo.listener.on('mutate::html', function ({ mutations }) {
    if (mutations.size > 10) {
        mutations.clear();
    }
})

xover.listener.on(`beforeFetch?request`, function ({ request, settings }) {
    let session_id = request.headers.get("x-session-id") || xo.session[`${request.url.host}:id`];
    session_id && request.headers.set("x-session-id", session_id);
})

xover.listener.on(`change::@state:fecha_embarque|@state:fecha_embarque_inicio|@state:fecha_embarque_fin`, function ({ value, store }) {
    xo.state.filterBy = 'ship_date'
    store.fetch()
})

xover.listener.on(`change::@state:fecha_recepcion|@state:fecha_recepcion_inicio|@state:fecha_recepcion_fin`, function ({ value, store }) {
    xo.state.filterBy = 'fecha_recepcion'
    store.fetch()
})

xover.listener.on(`change::@state:order|@state:purchase_order|@state:grower_lot`, function ({ value, store }) {
    xo.state.filterBy = this.localName.toLowerCase()
    store.fetch()
})
xover.listener.on(`change::@state:start_week|@state:end_week`, function ({ element, store }) {
    xo.state.filterBy = 'weeks'
    store.fetch()
})
xover.listener.on(`change::@state:fecha_inicio|@state:fecha_fin`, function ({ element, store }) {
    xo.state.filterBy = 'dates'
    store.fetch()
})

xover.listener.on(`change?xo.site.seed=#estado_resultados_semanal::@state:start_week|@state:end_week`, function () {
    /*Prevents auto fetch*/
    event.stopImmediatePropagation()
})

mostrarRegistros = function () {
    let scope = this.scope;
    let document = scope.ownerDocument;
    document.url.searchParams.set("@max_records", scope.value)
    document.fetch()
}

xover.listener.on('click::.filterable', function () {
    if (!selection.cells.length || selection.cells.concat(this).includes(this.closest('td,.cell'))) {
        let filters = selection.cells.concat(this).map(cell => cell.scope).reduce((result, scope) => { result[scope.localName] = (result[scope.localName] || []); result[scope.localName].push(scope.value); return result }, {});
        let scope = this.scope;
        let model = scope.closest("model");
        let target = scope.selectSingleNode(`ancestor::*[parent::model]`);
        if (target.hasAttributeNS('http://panax.io/state/filter', `${scope.localName}`)) {
            target.removeAttributeNS('http://panax.io/state/filter', `${scope.localName}`)
            delete filters[scope.localName]
        }


        for (let key of Object.keys(filters)) {
            target.setAttributeNS('http://panax.io/state/filter', `filter:${key}`, filters[key].distinct().join("|"))
        }
    }
})

//xover.listener.on('click::table .groupable', function () {
//    let groupBy = this.scope.nodeName.toLowerCase()
//    xo.state.groupBy = xo.state.groupBy == groupBy ? null : groupBy;
//})

xo.listener.on("fetch::#detalle_gastos_operativos|#detalle_ingresos_operativos|#detalle_ingresos|#detalle_egresos", function ({ source }) {
    delete source.definition["server:request"]["@max_records"]

    if (xo.site.searchParams.params.size) {
        debugger
    }
})

xo.listener.on(["fetch?href=^server/::*", "fetch?host=^server.panax.io::*", "fetch?host=*.ngrok*"], function ({ response, document, url }) {
    if (!(document && document.nodeType === Node.DOCUMENT_NODE)) return;
    for (let stylesheet of document.stylesheets || []) {
        let href = stylesheet.href;
        if (!href) continue;
        stylesheet.href = href.replace(/^([^/.])/, '/$1')
    }
    // backwards compatibility
    for (let control of document.select(`//*[not(@navbar:control)]/@navbar:filter`)) {
        control.parentNode.removeAttribute("navbar:position")
        control.remove()
    }
    for (let row of document.select(`//row[@state:page]`)) {
        let url = document.url.clone();
        url.searchParams.set("@page_index", row.getAttributeNodeNS("http://panax.io/state", "page"));
        url.fetch().then(document => {
            row.replaceWith(...document.select(`//${row.parentNode.nodeName}/*`))
        })
    }
})

xo.listener.on(["fetch::*"], function ({ document, request }) {
    //if (document instanceof Comment && document.data == 'ack:empty') {
    //    throw (new Error(`La consulta no regresó un modelo válido. \nEsto es un error. Favor de reportarlo. \nCopie y pegue este código: \n${btoa(JSON.stringify(this.definition))}`));
    //}
    if (!instanceOf.call(request.context, Node)) return;
    let tr = request.context.selectFirst('//ventas|//movimientos|//trouble');
    if (tr) {
        let node = document.selectFirst('//ventas|//movimientos|//trouble');
        //node.ownerDocument.disconnect();
        if (!node) return;
        let attributes = tr.attributes.toArray().filter(attr => !attr.namespaceURI || ["http://panax.io/state/filter", "http://panax.io/state/group", "http://panax.io/state/hidden"].includes(attr.namespaceURI)).map(slot => slot.cloneNode());
        [...node.attributes].filter(attr => !attr.namespaceURI).remove();
        attributes.forEach(attr => node.setAttributeNode(attr));
    }
})

function sortRows(header) {
    let index = header.$$("preceding-sibling::*").reduce((index, el) => { index += el.colSpan || 0; return index }, 0);
    let direction = 1;
    let getValue = (el) => {
        let val = el.cells[index].getAttribute("value") || el.cells[index].textContent;
        let parsed_value = +val.replace(/\$|^#|,/g, '');
        return isNaN(parsed_value) ? val : parsed_value;
    };
    let compare = (next, curr) => {
        if (curr.classList.contains("header") || next.classList.contains("header")) {
            return 0;
        }
        let valueCurr = getValue(curr);
        let valueNext = getValue(next);
        if (typeof (valueNext.localeCompare) == 'function') {
            return direction * valueNext.localeCompare(valueCurr, undefined, { sensitivity: 'accent', caseFirst: 'upper' });
        } else {
            return direction * (valueNext - valueCurr);
        }
    }
    [...header.parentNode.querySelectorAll('.sorted')].filter(th => th != header).forEach(th => th.classList.remove('sorted-desc', 'sorted-asc', 'sorted'));
    for (let tbody of header.closest('table').select('tbody')) {
        let rows = [...tbody.querySelectorAll("tr")];
        if (header.classList.contains("sorted-desc")) {
            index = 0;
            rows.sort(compare);
        } else if (header.classList.contains("sorted")) {
            direction = -1;
            rows.sort(compare);
        } else {
            rows.sort(compare);
        }
        tbody.replaceChildren(...rows);
    }
    if (header.classList.contains("sorted-desc")) {
        header.classList.remove("sorted", "sorted-desc");
    } else if (header.classList.contains("sorted")) {
        header.classList.remove("sorted-asc");
        header.classList.add("sorted", "sorted-desc");
    } else {
        header.classList.add("sorted", "sorted-asc");
    }
}

xo.listener.on('xover-initializing', function ({ progress_renders }) {
    if ('#loading' in xover.manifest.sources) {
        progress_renders.concat(xover.sources['#loading'].render());
    }
})

xover.listener.on('Response:reject?status=401&bodyType=html', function ({ }) {
    return { "message": "" };
})

xover.listener.on('change::@filter:*|@group:*', function ({ store }) {
    store.save()
})

//xo.listener.on(`change?!!srcElement.matches('[type=date]')`, function({ old }) {
//    debugger
//})

xo.listener.on('keyup', function () {
    if (event.key === 'Escape' && xo.site.sections["liquidation_report.xslt"].length) {
        xover.stores.active.select(`//ventas/@filter:*`).remove()
    }
})

xo.listener.on(`beforeTransform?stylesheet.href=ventas_por_fecha_embarque.xslt`, function ({ document }) {
    let rows = document.select(`//ventas/row`);
    let page_size = 400;
    if (rows.length <= 2000) return;
    rows.slice(page_size).filter((row, ix) => (ix % page_size) > 0).remove();
    rows.filter(el => el.parentNode).slice(page_size).forEach((el, ix) => {
        el.setAttribute("page:index", ix + 2)
        el.setAttribute("page:size", page_size)
    });
})

xo.listener.on(`intersect::tbody:has(.skeleton)`, async function () {
    let scope = this.scope;
    if (scope.nodeType != Node.ELEMENT_NODE) return;
    let document = scope.ownerDocument.cloneNode(true);
    document.disconnect();
    document.dispatch('filter');
    scope = document.findById(scope.attribute["xo:id"])
    let rows = document.select(`//ventas/row`);
    let ix = rows.indexOf(scope);
    let page_size = 400;
    rows.splice(0, ix).forEach(node => node.remove());
    rows.splice(page_size).forEach(node => node.remove());
    let html = await document.transform(this.section.stylesheet, { async: true })
    this.replaceWith(html.querySelector("tbody"))
})

//xo.listener.on(`beforeTransform?stylesheet.href=ventas_por_fecha_embarque.xslt`, function ({ document }) {
//    const rows = document.select(`//ventas/row`);
//    const groupAttrs = document.select(`//ventas/@group:*`);
//    const page_size = 400;

//    if (rows.length <= 2000) return;

//    const assignPage = (page, groupRows) => {
//        for (const row of groupRows) {
//            row.setAttribute("page:index", page);
//            row.setAttribute("page:size", page_size);
//        }
//    };

//    if (groupAttrs.length) {
//        // Agrupado: calcular clave compuesta por los atributos group:*
//        const getGroupKey = row =>
//            groupAttrs.map(attr => row.getAttribute(attr.name.split(':').pop()) || '').join('|');

//        const grouped = new Map();
//        for (const row of rows) {
//            const key = getGroupKey(row);
//            if (!grouped.has(key)) grouped.set(key, []);
//            grouped.get(key).push(row);
//        }

//        let currentPage = 1;
//        let currentPageRows = [];

//        for (const groupRows of grouped.values()) {
//            if (currentPageRows.length + groupRows.length > page_size) {
//                assignPage(currentPage, currentPageRows);
//                currentPage++;
//                currentPageRows = [];
//            }
//            currentPageRows.push(...groupRows);
//        }
//        if (currentPageRows.length) assignPage(currentPage, currentPageRows);
//    } else {
//        // Sin agrupamiento: asignar páginas directamente
//        rows.forEach((row, i) => {
//            const page = Math.floor(i / page_size) + 1;
//            row.setAttribute("page:index", page);
//            row.setAttribute("page:size", page_size);
//        });
//    }

//    // Eliminar filas que no pertenezcan a la primera página
//    rows.filter(r => r.getAttribute("page:index") !== "1").forEach(r => r.remove());
//});

//xo.listener.on(`intersect::tbody:has(.skeleton)`, async function () {
//    let scope = this.scope;
//    if (scope.nodeType != Node.ELEMENT_NODE) return;
//    let document = scope.ownerDocument.cloneNode(true);
//    document.disconnect();
//    document.dispatch('filter');
//    scope = document.findById(scope.attribute["xo:id"])
//    let rows = document.select(`//ventas/row`);
//    let ix = rows.indexOf(scope);
//    let page_size = 400;
//    let start = ix - (ix % page_size);
//    let end = start + page_size;

//    rows.forEach((node, i) => {
//        if (i < start || i >= end) node.remove();
//    });

//    let html = await document.transform(this.section.stylesheet)
//    this.replaceWith(html.querySelector("tbody"))
//})

function updateNgrok() {
    try {
        let gist = xover.session.gist;
        if (!gist) return;
        fetch(gist)
            .then(res => res.json())
            .then(json => xover.session.server = json["ngrokUrl"])
    } catch (e) {
        console.error(e)
    }
}

async function refreshStorehouse(key) {
    if (key) {
        let store = await xover.storehouse.sources;
        await store.delete(key)
    }
    this.store.reload()
}