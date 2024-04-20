xo.spaces["expanded"] = "http://panax.io/state/expanded";
xo.spaces["visible"] = "http://panax.io/state/visible";
xo.spaces["hidden"] = "http://panax.io/state/hidden";
async function progressiveRequest(params) {
    if (params instanceof Array) {
        params = Object.fromEntries(params);
    }
    let store = xo.stores.seed;
    if (store.selectFirst(`/model/fechas`)) {
        params["@get_dims"] = 0;
    }
    let response = {};
    let source = this;
    let loading, progress;
    if (Object.keys(params).filter(key => key.match(/@get_n\d/)).length) {
        this.settings.progress = await xo.sources["loading.xslt"].render();
        progress = this.settings.progress[0].querySelector('i progress');
        progress.style.display = 'inline';
    }
    let requested_levels = Object.entries(params).filter(([key, value]) => key.match(/@get_n\d/) && value == 1).map(([key]) => key.replace(/@get_n(\d+)/, '$1')).order();
    //Object.keys(params).filter(key => key.match(/@get_n\d/)).forEach((key, ix) => {
    //    if (ix == 0) {
    let new_params = params;//Object.fromEntries(Object.entries(params).filter(([key]) => !key.match(/@get_n\d/)));
    //new_params[key] = params[key];
    progress && progress.appendAfter(xo.xml.createNode(`<label xmlns="http://www.w3.org/1999/xhtml" style="white-space: nowrap; font-size: xx-small; transform: translateY(-40px); color: white; font-weight: bolder;">Cargando nivel ${requested_levels.join(', ')}...</label>`));
    response = xo.server.request.call(this, new_params, { source: source, progress: progress }).then(document => {
        //delete params[key];
        let items = document.select(`/model/polizas|/model/presupuesto`).filter(item => item.firstElementChild);
        document.seed();

        let current_date_er = new Date().toISOString().replace('-', '').substring(0, 6);
        let fechas = document.selectFirst(`model/fechas`);
        if (fechas) {
            fechas.set("state:current_date_er", current_date_er);
        }

        let target_model = store.selectFirst(`/model`);
        if (target_model) {
            //store.document.disconnect();
            for (item of items) {
                let dims = item.select(`@div|@rs|@un`);
                let levels = [...new Set(item.select(`*/@n1|*/@n2|*/@n3|*/@n4|*/@n5|*/@n6`).map(n => n.value))];
                let matches = target_model.select(`${item.nodeName}${dims.map(el => `[@${el.name}="${el.value}"]`).join('')}`);
                if (!matches.length) {
                    target_model.append(item)
                } else {
                    for (let target of matches) {
                        target.select(`*/@n1|*/@n2|*/@n3|*/@n4|*/@n5|*/@n6`).filter(attr => levels.includes(attr.value)).forEach(attr => attr.remove({ silent: true }));
                        target.select(`*[not(@n1 or @n2 or @n3 or @n4 or @n5 or @n6)]`).forEach(el => el.remove({ silent: true }));
                        target.append(...item.select('*'));
                    }
                }
                //xo.stores.seed.select(`/model/polizas/*/@n${key.substring(6)}`).forEach(el => Element.remove.apply(el.parentNode));
                //xo.stores.seed.select(`/model/presupuesto/*/@n${key.substring(6)}`).forEach(el => Element.remove.apply(el.parentNode));
                //xo.stores.seed.select('//model').forEach(polizas => polizas.append(...document.select('//model/polizas'), { silent: true }));
                //xo.stores.seed.select('/model').forEach(polizas => polizas.append(...document.select('/model/presupuesto'), { silent: true }));
            }
            xo.stores.seed.document.connect();
        }

        //progressiveRequest.call(this, params);
        xo.stores.seed.render();
        if (xo.stores.seed.documentElement) {
            return Promise.resolve(xo.stores.seed.document);
        } else {
            return Promise.resolve(document);
        }
    }).catch(e => {
        return Promise.reject(e);
    }).finally(() => {
        loading && loading.forEach(el => el.remove());
    });
    //    }
    //});
    return response;
}

xo.listener.on(['xo.Source:fetch', 'xo.Source:failure'], async function ({ settings = {} }) {
    let progress = await settings.progress;
    progress && progress.remove();
})

Object.defineProperty(xo.session, 'login', {
    value: async function (username, password, connection_id) {
        try {
            xover.session.user_login = username
            xover.session.status = 'authorizing';
            let response = await xover.server.login(new URLSearchParams({ 'connection_id': connection_id }), { headers: { authorization: `Basic ${btoa(username + ':' + password)}` } });
            xover.session.status = 'authorized';
            xover.stores.active.render();
        } catch (e) {
            xover.session.status = 'unauthorized';
            Promise.reject(e);
        }
    }, writable: true, configurable: true
})

Object.defineProperty(xo.session, 'logout', {
    value: async function () {
        try {
            let response = await xover.server.logout();
            for (store in xo.stores) {
                xo.stores[store].remove()
            }
            xover.session.status = 'unauthorized';
            history.go(-xo.site.position + 1);
        } catch (e) {
            Promise.reject(e);
        }
    }, writable: true, configurable: true
})

xo.listener.on('beforeRender?!store.stylesheets.length::model[not(//processing-instruction())]', function ({ document, store }) {
    let tag = store.tag;
    store.addStylesheet({ href: tag.substring(1).split(/\?/, 1).shift() + '.xslt', target: "@#shell main" });
})

xo.listener.on(['beforeFetch::#polizas', 'beforeFetch::#capital_trabajo', 'beforeFetch::#flujo_efectivo', 'beforeFetch::#razones_financieras', 'beforeFetch::#concentrado_er_balance', 'beforeFetch::#productividad_individual'], function () {
    this.settings.progress = xo.sources["loading.xslt"].render();
})

xo.listener.on('hashchange', function () {
    typeof (toggleSidebar) === 'function' && toggleSidebar(false)
})

xo.listener.on('progress', async function ({ percent }) {
    let progress = await this.settings.progress;
    if (progress) {
        progress = [progress].flat(Infinity);
        let target = progress[0].parentNode?.querySelector('progress');
        if (target) {
            target.style.display = 'inline'
            target.value = percent;
        }
    }
})

xo.listener.on(['beforeRender::#shell.xslt', 'beforeAppendTo::main', 'beforeAppendTo::body'], function ({ target }) {
    if (!(event.detail.args || []).filter(el => !(el instanceof Comment || el instanceof HTMLStyleElement || el instanceof HTMLScriptElement || el.matches("dialog,[role=alertdialog],[role=alert],[role=dialog],[role=status],[role=progressbar]"))).length) return;
    [...target.childNodes].filter(el => el.matches && !el.matches(`script,dialog,[role=alertdialog],[role=alert],[role=dialog],[role=status],[role=progressbar]`)).removeAll()
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

function DynamicObject(obj) {
    if (!(this instanceof DynamicObject)) return new DynamicObject(obj);
    let proxy_manager = function (target, name) {
        let return_value
        if (["getValue", "hasOwnProperty", "realValue"].includes(name) || typeof target[name] === 'function') {
            return target[name];
        }
        if (name in target && target[name] !== undefined && target[name] !== null) {
            if (typeof (target[name]) == 'string') {
                return_value = new String(target[name]);
            } else if (typeof (target[name]) == 'number') {
                return_value = new Number(target[name]);
            } else if (typeof (target[name]) == 'boolean') {
                return_value = new Boolean(target[name]);
            } else if (target[name].constructor === {}.constructor) {
                return_value = new Proxy(target[name], { get: proxy_manager });
            } else {
                return_value = target[name];
            }
        } else {
            return_value = new Proxy({}, { get: proxy_manager });
            Object.setPrototypeOf(return_value, Array.prototype)
            Object.defineProperty(return_value, 'realValue', {
                value: undefined,
                writable: true, enumerable: false, configurable: false
            });
        }
        if (!(return_value.hasOwnProperty('getValue'))) {
            Object.defineProperty(return_value, 'getValue', {
                value: function () {
                    if (this.hasOwnProperty('realValue')) {
                        return this.realValue;
                    } else {
                        return target[name];
                    }
                },
                writable: false, enumerable: false, configurable: false
            });
        }
        return return_value;
    }
    let new_obj = new Proxy(obj, { get: proxy_manager });
    Object.setPrototypeOf(new_obj, this);
    return new_obj;
}

xo.listener.on('beforeTransform?stylesheet.href=^page_controls.*\\.xslt?stylesheet.href=page_navbar.xslt::model', function ({ target, store, stylesheet }) { //remueve todos los facts
    let explicit_dims = ["fechas", "mantenibles"];
    this.select(`/model/*[not(*[@id] or ${explicit_dims.map(dim => `self::${dim}`).join(" or ")})]|/model/*[line]`).forEach(el => Element.remove.apply(el));
})

xo.listener.on('beforeTransform::model', function ({ target, store, stylesheet }) {
    this.select(`//razones_sociales[not(@state:checked)][not(razon_social[2])]/razon_social`).forEach(target => target.setAttribute("state:checked", "true"));
    this.select(`//divisiones[not(@state:checked)][not(division[2])]/division`).forEach(target => target.setAttribute("state:checked", "true"));
})

xo.listener.on('beforeTransform::model', function ({ target, store, stylesheet }) {
    this.select(`//divisiones/division[not(@id=//razones_sociales/razon_social/@div)]`).forEach(division => division.remove())
})

xo.listener.on('beforeTransform?stylesheet.href=^page_controls.*\\.xslt?stylesheet.href=page_navbar.xslt::model', function ({ target, store, stylesheet }) { //remueve todos los facts
    let dims = ["fechas"];
    !event.detail.keep_DIVS && this.select(`/model[razones_sociales/razon_social[@state:checked="true"]]/divisiones/division[not(@state:checked="true")]/@nom`).forEach(el => el.parentNode.replaceWith(new Comment(`${el.parentNode.nodeName}: ${el.value}`)));
    this.select(`/model[not(razones_sociales/razon_social[@state:checked="true"])]/unidades_negocio/unidad_negocio`).forEach(el => Element.remove.apply(el));
})

xo.listener.on('beforeTransform?stylesheet.href=title.xslt?stylesheet.href=shell_buttons.xslt?stylesheet.href=page_navbar.xslt?stylesheet.href=^page_controls\\..*\\.xslt::model', function ({ stylesheet }) {
    event.detail.keepDimensions = true;
    event.stopImmediatePropagation()
})

xo.listener.on(['replaceWith::[xo-stylesheet="page_controls.mantenibles.xslt"]'], ({ new_node, old }) => {
    if (!new_node.childNodes.length) {
        new_node.replaceChildren(...old.childNodes)
        //new_node.querySelectorAll("[xo-stylesheet]").toArray().concat([new_node].filter(el => el.matches("[xo-stylesheet]")))
    }
})

xo.listener.on(['transform'], ({ result }) => {
    result.$$('//text()[.="Infinity" or .="-Infinity" or .="NaN" or .="NaN días" or .="0.0" or .="0.0%" or .="(0.0)" or .="0.00" or .="0" or .="(0)" or .="$0"]').remove()
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

async function generateExcelFile(table, name) {
    let progress = await xo.sources["loading.xslt"].render();
    await xover.delay(500);
    //if (this.Interval) window.clearInterval(this.Interval);
    let _progress = 0;
    let progress_bar = progress[0].querySelector('progress');
    progress_bar.style.display = 'inline';

    //this.Interval = setInterval(function () {
    //    if (progress_bar) {
    //        progress_bar.value = _progress;
    //        console.log(_progress);
    //    }
    //}, 500);
    table = table.cloneNode(true);
    table.querySelectorAll('del,.hidden').toArray().remove();
    let set_computed_background = function (cell) {
        let border = cell.style.border;
        let backgroundColor = cell.style.backgroundColor;
        let color = cell.style.color;
        let styleSheets = document.styleSheets;
        for (let styleSheet of [...styleSheets]) {
            for (let rule of [...styleSheet.rules].filter(rule => rule.selectorText && (rule.style.border || rule.style.backgroundColor || rule.style.color) && cell.matches(rule.selectorText))) {
                if (!border && rule.style.border) {
                    cell.style.border = rule.style.border;
                }
                if (!backgroundColor && rule.style.backgroundColor) {
                    cell.style.backgroundColor = rule.style.backgroundColor;
                }
                if (!color && rule.style.color) {
                    cell.style.color = rule.style.color;
                }
            }
        }
    }
    let rows = table.getElementsByTagName("tr");
    let r = 0;
    for (let row of rows) {
        ++r;
        _progress = r / rows.length * 100;
        [...row.getElementsByTagName("td")].forEach(el => set_computed_background(el));
        if (r % (rows.length / 10) == 0) {
            progress_bar.value = _progress;
            await xover.delay(500);
        }
    }
    xo.dom.toExcel(table, name.split("?")[0])
    progress.remove();
    if (this.Interval) window.clearInterval(this.Interval);
}

xo.listener.on("mousedown", function (event) {
    if (!(event && event.buttons == 1 && (this.closest('.validation-enabled, .blacklist-enabled, .selection-enabled') || window.getComputedStyle(this).cursor == 'cell'))) return
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

xo.listener.on("mousemove", async function (event) {
    if (!(event && event.buttons == 1 && (this.closest('.validation-enabled, .blacklist-enabled, .selection-enabled') || window.getComputedStyle(this).cursor == 'cell'))) return
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
    if (!(this.closest('.validation-enabled, .blacklist-enabled, .selection-enabled') || window.getComputedStyle(this).cursor == 'cell')) return;
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
        if (selection_started) {
            let cell = window.getComputedStyle(this).cursor == 'cell' && this || this.closest(".cell");
            cell && cell.classList.add("selection-end");
            let offcanvas = this.closest(".cell") && document.querySelector('#offcanvasSelection');
            if (offcanvas) {
                new bootstrap.Offcanvas(offcanvas).toggle()
                //let rows = parent_container.querySelectorAll("tr:has(.cell.selected)"); // Esta parte del código tiene problemas de rendimiento con datasets grandes por recálculos en estilos
                //for (let [r, row] of rows.entries()) {
                //    if (r == 0) row.classList.add("top-selection");
                //    if (r == rows.length - 1) row.classList.add("bottom-selection");
                //    let cols = row.querySelectorAll(".cell.selected");
                //    for (let [c, col] of cols.entries()) {
                //        if (c == 0) col.classList.add("left-selection");
                //        if (c == cols.length - 1) col.classList.add("right-selection");
                //    }
                //}
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
                target.querySelector('.valor').classList.remove('d-none');
                let sum = selection.sum();
                //let map = selection.groupDimensions()
                target.valor.value = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(sum);

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
                return this.map(el => {
                    let dims = ["div", "rs", "un", "prod", "cta", "indicador", "cl", "fecha", "value"];
                    let cell = el.select(dims.map(dim => `ancestor-or-self::*/@${dim}[1]`).join("|")).filter(attr => attr.value).reduce((cell, attr) => { cell[attr.name] = attr.value || ''; return cell }, {});

                    if (!cell.hasOwnProperty("value")) {
                        let value = (el.querySelector("input") || el).value;
                        cell["value"] = parseFloat(value.replace(/%|\$|,/g, '').replace(/\(/g, '-')) || 0;
                    }
                    return parseFloat(cell["value"] || 0)
                }).filter(value => isFinite(value)).reduce((sum, item) => sum + item, 0)
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

xo.listener.on(`input::input[type=search]`, function (event) {
    const input = this;
    clearTimeout(input.search_timeout);
    this.search_timeout = setTimeout(() => {
        //let scope = input.scope;
        //scope.value = input.value;
        let search_text = input.value;//this.documentElement.getAttribute("state:filter");
        let inverted = search_text[0] == '!';
        search_text = search_text.replace(/^\!/, '');
        let records = this.closest('table,form').select(`.//tr/@desc_poliza|.//select/option/text()`)
        records.forEach(record => record.parentNode.classList.remove('hidden'));
        for (let attr of records.filter(desc => inverted !== !desc.value.match(new RegExp(search_text, "ig")))) {
            attr.parentNode.classList.add('hidden')
        }
        clearTimeout(input.search_timeout);
    }, 100);
});

xo.listener.on(`change::@state:date`, function ({ value, event }) {
    let srcElement = event.srcElement;
    let store = srcElement.store;
    if (!store) return;
    store.source.definition["server:request"]["@month"] = value;
    store.document.fetch();
})

xo.listener.on(`beforeTransform?stylesheet.href=estado_resultados_semanal.xslt`, function ({ document }) {
    let start_week = this.selectFirst(`//fechas/@state:start-week`)
    if (start_week) {
        this.select(`//fechas/row[@desc="${start_week}"]`).forEach(el => el.select(`preceding-sibling::*`).remove())
    }
    let end_week = this.selectFirst(`//fechas/@state:end-week`)
    if (end_week) {
        this.select(`//fechas/row[@desc="${end_week}"]`).forEach(el => el.select(`following-sibling::*`).remove())
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

xo.listener.on('submit', async function () {
    [...this.querySelectorAll(`[xo-slot]`)].filter(el => el.value && el.scope && el.scope.value === null).forEach(el => typeof (el.onchange) == 'function' ? el.onchange.call(el) : el.scope.set(el.value))
})

xover.listener.on('Response:failure?status=401', function ({ url }) {
    if (['server.panax.io'].includes(url.host)) {
        xo.session.status = 'unauthorized'
    }
})