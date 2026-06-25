document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("[data-confirm]").forEach(function (form) {
        form.addEventListener("submit", function (event) {
            if (!confirm(form.getAttribute("data-confirm"))) {
                event.preventDefault();
            }
        });
    });

    var currentPath = window.location.pathname;
    document.querySelectorAll(".nav-links a").forEach(function (link) {
        var href = link.getAttribute("href");
        if (!href) {
            return;
        }
        if (href === currentPath || (href !== "/" && currentPath.indexOf(href) === 0)) {
            link.classList.add("is-active");
        }
    });
    document.querySelectorAll(".admin-menu a").forEach(function (link) {
        var href = link.getAttribute("href");
        if (!href) {
            return;
        }
        if (href === currentPath || (href !== "/admin" && currentPath.indexOf(href) === 0)) {
            link.classList.add("is-active");
        }
        if (href === "/admin" && currentPath === "/admin") {
            link.classList.add("is-active");
        }
    });

    var revealTargets = document.querySelectorAll(
        ".section-title, .category-card, .product-card, .nutrition-card, .stat-card, .panel, .table, .tool-panel, .cart-item, .order-card, .detail-product, .hero-card"
    );

    if ("IntersectionObserver" in window) {
        var observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add("is-visible");
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.12 });

        revealTargets.forEach(function (target, index) {
            target.classList.add("reveal-on-scroll");
            target.style.transitionDelay = Math.min(index % 8, 7) * 45 + "ms";
            observer.observe(target);
        });
    } else {
        revealTargets.forEach(function (target) {
            target.classList.add("is-visible");
        });
    }

    var heroSlides = document.querySelectorAll("[data-hero-slider] .hero-slide");
    if (heroSlides.length > 1) {
        var heroIndex = 0;
        setInterval(function () {
            heroSlides[heroIndex].classList.remove("is-active");
            heroIndex = (heroIndex + 1) % heroSlides.length;
            heroSlides[heroIndex].classList.add("is-active");
        }, 4200);
    }

    document.querySelectorAll("[data-payment-method]").forEach(function (select) {
        var form = select.closest("form");
        var panel = form && form.querySelector("[data-bank-transfer-panel]");
        var submitText = form && form.querySelector("[data-checkout-submit-text]");
        var customerNameInput = form && form.querySelector("[data-checkout-customer-name]");
        var phoneInput = form && form.querySelector("[data-checkout-phone]");
        var vietQrImg = form && form.querySelector("[data-vietqr-img]");
        var transferNote = form && form.querySelector("[data-transfer-note]");

        function getTransferNote() {
            var customerName = customerNameInput && customerNameInput.value ? customerNameInput.value.trim() : "";
            var phone = phoneInput && phoneInput.value ? phoneInput.value.replace(/[^\d]/g, "") : "";
            if (customerName && phone) {
                return customerName + " " + phone;
            }
            return customerName || phone || "BOXHEALTHY";
        }

        function syncVietQr() {
            var note = getTransferNote();
            if (transferNote) {
                transferNote.textContent = note;
            }
            if (!vietQrImg) {
                return;
            }

            var params = new URLSearchParams({
                amount: vietQrImg.dataset.amount || "0",
                addInfo: note,
                accountName: vietQrImg.dataset.accountName || "DUONG THI YEN NHI"
            });
            vietQrImg.src = "https://img.vietqr.io/image/TPB-00000817755-print.png?" + params.toString();
        }

        function syncPaymentUi() {
            var isBankTransfer = select.value === "BANK_TRANSFER";
            if (panel) {
                panel.hidden = !isBankTransfer;
            }
            if (submitText) {
                submitText.textContent = isBankTransfer ? "Xác nhận chuyển khoản" : "Đặt hàng";
            }
            if (isBankTransfer) {
                syncVietQr();
            }
        }

        select.addEventListener("change", syncPaymentUi);
        if (customerNameInput) {
            customerNameInput.addEventListener("input", syncVietQr);
        }
        if (phoneInput) {
            phoneInput.addEventListener("input", syncVietQr);
        }
        syncPaymentUi();
    });

    var checkoutForm = document.getElementById("checkoutForm");
    var checkoutModal = document.querySelector("[data-checkout-confirm-modal]");
    if (checkoutForm && checkoutModal) {
        var paymentMethodSelect = checkoutForm.querySelector("[data-payment-method]");
        var submitButton = checkoutForm.querySelector("[data-checkout-submit]");
        var modalTitle = checkoutModal.querySelector("#checkoutConfirmTitle");
        var modalMessage = checkoutModal.querySelector("[data-checkout-confirm-message]");
        var confirmButton = checkoutModal.querySelector("[data-checkout-confirm-ok]");
        var cancelButtons = checkoutModal.querySelectorAll("[data-checkout-confirm-cancel]");

        function getPaymentMethodLabel() {
            return paymentMethodSelect && paymentMethodSelect.value === "BANK_TRANSFER"
                ? "Xác nhận chuyển khoản"
                : "Đặt hàng";
        }

        function openCheckoutConfirm() {
            var isBankTransfer = paymentMethodSelect && paymentMethodSelect.value === "BANK_TRANSFER";
            if (modalTitle) {
                modalTitle.textContent = isBankTransfer
                    ? "Bạn đã chuyển khoản cho đơn này?"
                    : "Bạn chắc chắn muốn đặt đơn?";
            }
            if (modalMessage) {
                modalMessage.textContent = isBankTransfer
                    ? "Sau khi xác nhận, Box Healthy sẽ ghi nhận đơn và kiểm tra giao dịch chuyển khoản."
                    : "Box Healthy sẽ ghi nhận đơn COD và liên hệ xác nhận sớm.";
            }
            if (confirmButton) {
                confirmButton.textContent = getPaymentMethodLabel();
            }
            checkoutModal.hidden = false;
            document.body.classList.add("modal-open");
        }

        function closeCheckoutConfirm() {
            checkoutModal.hidden = true;
            document.body.classList.remove("modal-open");
        }

        if (submitButton) {
            submitButton.addEventListener("click", function () {
                if (checkoutForm.reportValidity && !checkoutForm.reportValidity()) {
                    return;
                }
                openCheckoutConfirm();
            });
        }

        checkoutForm.addEventListener("submit", function (event) {
            event.preventDefault();
            if (checkoutForm.reportValidity && !checkoutForm.reportValidity()) {
                return;
            }
            openCheckoutConfirm();
        });

        if (confirmButton) {
            confirmButton.addEventListener("click", function () {
                closeCheckoutConfirm();
                checkoutForm.submit();
            });
        }

        cancelButtons.forEach(function (button) {
            button.addEventListener("click", closeCheckoutConfirm);
        });

        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape" && !checkoutModal.hidden) {
                closeCheckoutConfirm();
            }
        });
    }

    document.querySelectorAll("[data-toggle-detail]").forEach(function (button) {
        button.addEventListener("click", function () {
            var card = button.closest(".nutrition-card");
            if (card) {
                card.classList.toggle("is-open");
            }
        });
    });

    document.querySelectorAll(".admin-upload-box input[type='file']").forEach(function (input) {
        input.addEventListener("change", function () {
            var file = input.files && input.files[0];
            if (!file || !file.type || file.type.indexOf("image/") !== 0) {
                return;
            }
            var uploadBox = input.closest(".admin-upload-box");
            if (!uploadBox) {
                return;
            }
            var preview = uploadBox.querySelector("img");
            if (!preview) {
                preview = document.createElement("img");
                uploadBox.insertBefore(preview, uploadBox.firstChild);
            }
            preview.src = URL.createObjectURL(file);
            preview.alt = "Ảnh vừa chọn";
        });
    });

    document.querySelectorAll("[data-ingredient-builder]").forEach(function (builder) {
        var rowsWrap = builder.querySelector("[data-ingredient-rows]");
        var addButton = builder.querySelector("[data-add-ingredient]");
        var template = document.getElementById("ingredient-row-template");
        var form = builder.closest("form");

        function round1(value) {
            return Math.round(value * 10) / 10;
        }

        function numberFrom(value) {
            var parsed = parseFloat(value);
            return isNaN(parsed) ? 0 : parsed;
        }

        function reindexRows() {
            rowsWrap.querySelectorAll("[data-ingredient-row]").forEach(function (row, index) {
                row.querySelectorAll("input, select").forEach(function (field) {
                    var name = field.getAttribute("name");
                    if (name) {
                        field.setAttribute("name", name.replace(/ingredients\[\d+]/, "ingredients[" + index + "]"));
                    }
                });
            });
        }

        function calculateRow(row) {
            var select = row.querySelector("[data-nutrition-select]");
            var weightInput = row.querySelector("[data-ingredient-weight]");
            var selected = select && select.options[select.selectedIndex];
            var gram = numberFrom(weightInput && weightInput.value);
            var ratio = gram / 100;
            var calories = Math.round(numberFrom(selected && selected.dataset.calories) * ratio);
            var protein = round1(numberFrom(selected && selected.dataset.protein) * ratio);
            var carbs = round1(numberFrom(selected && selected.dataset.carbs) * ratio);
            var fat = round1(numberFrom(selected && selected.dataset.fat) * ratio);

            row.querySelector("[data-row-calories]").textContent = calories;
            row.querySelector("[data-row-protein]").textContent = protein + "g";
            row.querySelector("[data-row-carbs]").textContent = carbs + "g";
            row.querySelector("[data-row-fat]").textContent = fat + "g";

            return { calories: calories, protein: protein, carbs: carbs, fat: fat };
        }

        function calculateTotals() {
            var totals = { calories: 0, protein: 0, carbs: 0, fat: 0 };
            rowsWrap.querySelectorAll("[data-ingredient-row]").forEach(function (row) {
                var rowTotals = calculateRow(row);
                totals.calories += rowTotals.calories;
                totals.protein += rowTotals.protein;
                totals.carbs += rowTotals.carbs;
                totals.fat += rowTotals.fat;
            });

            var caloriesInput = form && form.querySelector("[data-total-calories]");
            var proteinInput = form && form.querySelector("[data-total-protein]");
            var carbsInput = form && form.querySelector("[data-total-carbs]");
            var fatInput = form && form.querySelector("[data-total-fat]");
            if (caloriesInput) caloriesInput.value = totals.calories || "";
            if (proteinInput) proteinInput.value = totals.protein ? round1(totals.protein) : "";
            if (carbsInput) carbsInput.value = totals.carbs ? round1(totals.carbs) : "";
            if (fatInput) fatInput.value = totals.fat ? round1(totals.fat) : "";
        }

        function bindRow(row) {
            row.querySelectorAll("[data-nutrition-select], [data-ingredient-weight]").forEach(function (field) {
                field.addEventListener("change", calculateTotals);
                field.addEventListener("input", calculateTotals);
            });
            var removeButton = row.querySelector("[data-remove-ingredient]");
            if (removeButton) {
                removeButton.addEventListener("click", function () {
                    row.remove();
                    reindexRows();
                    calculateTotals();
                });
            }
        }

        rowsWrap.querySelectorAll("[data-ingredient-row]").forEach(bindRow);

        if (addButton && template) {
            addButton.addEventListener("click", function () {
                var index = rowsWrap.querySelectorAll("[data-ingredient-row]").length;
                var html = template.innerHTML.replace(/__index__/g, index);
                var holder = document.createElement("div");
                holder.innerHTML = html.trim();
                var row = holder.firstElementChild;
                rowsWrap.appendChild(row);
                bindRow(row);
                reindexRows();
                calculateTotals();
            });
        }

        calculateTotals();
    });

    document.querySelectorAll(".btn, button").forEach(function (button) {
        button.addEventListener("click", function (event) {
            if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
                return;
            }
            var rect = button.getBoundingClientRect();
            var dot = document.createElement("span");
            dot.className = "ripple-dot";
            dot.style.left = event.clientX - rect.left + "px";
            dot.style.top = event.clientY - rect.top + "px";
            button.appendChild(dot);
            window.setTimeout(function () {
                dot.remove();
            }, 600);
        });
    });

    document.querySelectorAll("[data-ai-chat]").forEach(function (widget) {
        var toggle = widget.querySelector("[data-ai-chat-toggle]");
        var close = widget.querySelector("[data-ai-chat-close]");
        var panel = widget.querySelector(".ai-chat-panel");
        var form = widget.querySelector("[data-ai-chat-form]");
        var input = form && form.querySelector("input[name='message']");
        var messages = widget.querySelector("[data-ai-chat-messages]");
        var csrfToken = document.querySelector("meta[name='_csrf']");
        var csrfHeader = document.querySelector("meta[name='_csrf_header']");

        function setOpen(open) {
            if (!panel) {
                return;
            }
            panel.hidden = !open;
            widget.classList.toggle("is-open", open);
            if (open && input) {
                window.setTimeout(function () {
                    input.focus();
                }, 80);
            }
        }

        function appendMessage(type, text) {
            var message = document.createElement("div");
            message.className = "ai-chat-message " + type;
            message.textContent = text;
            messages.appendChild(message);
            messages.scrollTop = messages.scrollHeight;
            return message;
        }

        if (toggle) {
            toggle.addEventListener("click", function () {
                setOpen(panel && panel.hidden);
            });
        }
        if (close) {
            close.addEventListener("click", function () {
                setOpen(false);
            });
        }
        if (form) {
            form.addEventListener("submit", function (event) {
                event.preventDefault();
                var text = input && input.value ? input.value.trim() : "";
                if (!text) {
                    return;
                }
                appendMessage("user", text);
                input.value = "";
                var pending = appendMessage("bot is-loading", "Đang trả lời...");
                var headers = { "Content-Type": "application/json" };
                if (csrfToken && csrfHeader && csrfToken.content && csrfHeader.content) {
                    headers[csrfHeader.content] = csrfToken.content;
                }

                fetch((window.APP_CONTEXT_PATH || "") + "/api/chat", {
                    method: "POST",
                    headers: headers,
                    body: JSON.stringify({ message: text })
                })
                    .then(function (response) {
                        if (!response.ok) {
                            throw new Error("Chat request failed");
                        }
                        return response.json();
                    })
                    .then(function (data) {
                        pending.classList.remove("is-loading");
                        pending.textContent = data.reply || "Mình chưa có câu trả lời phù hợp.";
                    })
                    .catch(function () {
                        pending.classList.remove("is-loading");
                        pending.textContent = "Chat AI đang lỗi kết nối. Bạn thử lại sau nhé.";
                    });
            });
        }
    });
});
