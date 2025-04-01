// Add event listeners when the document is ready
document.addEventListener('DOMContentLoaded', function() {
    // Add click event listeners to edit buttons
    document.querySelectorAll('.edit-btn').forEach(button => {
        button.addEventListener('click', function() {
            const liftId = this.getAttribute('data-lift-id');
            editLift(liftId);
        });
    });

    // Add click event listeners to delete buttons
    document.querySelectorAll('.delete-btn').forEach(button => {
        button.addEventListener('click', function() {
            const liftId = this.getAttribute('data-lift-id');
            deleteLift(liftId);
        });
    });
});

function editLift(lift_id) {
    console.log(lift_id);
    
    // Create form data
    const formData = new FormData();
    formData.append('liftid', lift_id);

    // Make the AJAX request using fetch
    fetch('lifts.cfc?method=getLiftInfo&returnformat=json', {
        method: 'POST',
        body: formData,
        cache: 'no-store'
    })
    .then(response => response.json())
    .then(data => {
        showEditLiftDialog(data);
    })
    .catch(error => {
        console.error('Error:', error);
        alert('An error occurred while fetching lift information');
    });
}

function showEditLiftDialog(obj) {
    // Create modal dialog
    const dialog = document.createElement('div');
    dialog.className = 'modal-dialog';

    // Create backdrop
    const backdrop = document.createElement('div');
    backdrop.className = 'modal-backdrop';

    // Add dialog header
    const header = document.createElement('div');
    header.className = 'dialog-header';
    
    const title = document.createElement('h2');
    title.textContent = 'Edit Lift';
    header.appendChild(title);

    // Add close button
    const closeBtn = document.createElement('button');
    closeBtn.innerHTML = '&times;';
    closeBtn.onmouseover = () => closeBtn.style.color = '#333';
    closeBtn.onmouseout = () => closeBtn.style.color = '#666';
    header.appendChild(closeBtn);

    // Clone the lift info content
    const liftInfo = document.getElementById('lift_info');
    const content = liftInfo.cloneNode(true);
    content.style.display = 'block';

    // Add content to dialog
    dialog.appendChild(header);
    dialog.appendChild(content);

    // Helper function to safely set value
    const setValue = (selector, value) => {
        const element = content.querySelector(selector);
        if (element) {
            if (selector === '#delivery_date' || selector === '#end_date' || selector === '#rls_date') {
                // Format date for display
                if (value) {
                    const date = new Date(value);
                    if (!isNaN(date)) {
                        const year = date.getFullYear();
                        const month = String(date.getMonth() + 1).padStart(2, '0');
                        const day = String(date.getDate()).padStart(2, '0');
                        element.value = `${year}-${month}-${day}`;
                    }
                }
            } else {
                element.value = value;
            }
        }
    };

    // Helper function to safely set display
    const setDisplay = (selector, display) => {
        const element = content.querySelector(selector);
        if (element) {
            element.style.display = display;
        }
    };

    // Set form values safely
    setValue('#qty', obj.QTY);
    setValue('#est_cost', obj.ESTIMATEDCOST);
    setValue('#conf_number', obj.CONFIRMATIONNUMBER);
    setValue('#release_number', obj.RELEASENUMBER);
    setValue('#notes', obj.NOTES);
    setValue('#rls_date', obj.RELEASEDATE);
    setValue('#end_date', obj.ENDDATE);
    setValue('#closeout', "0");
    setValue('#lift_company', obj.LIFTCOMPANY);
    setValue('#equipmenttype', obj.EQUIPMENTTYPE);
    setValue('#release_with', obj.RELEASEWITH);
    setValue('#final_invoice_amt', obj.FINALINVOICEAMOUNT);
    setValue('#invoice_number', obj.INVOICENUMBER);
    setValue('#delivery_date', obj.DELIVERYDATE);
    setValue('#order_id', obj.ORDERID);
    setValue('#customer_id', obj.CUSTOMERID);
    setValue('#customer_site_id', obj.CUSTOMERSITEID);

    // Show lift detail section
    setDisplay('.lift-detail', 'block');

    // Handle FieldTech case
    if(obj.ISFIELDTECH == 1) {
        setValue('#lift_company', 'FieldTech');
        setValue('#lift_vendor', obj.LIFTCOMPANY);
        setDisplay('#disp_vendor', 'block');
    } else {
        if (obj.LIFTCOMPANY?.trim() !== "") {
            displayPhone(obj.LIFTCOMPANY);
        } else {
            const liftCompanySelect = content.querySelector('#lift_company');
            if (liftCompanySelect) {
                displayPhone(liftCompanySelect.value);
            }
        }
        setDisplay('#disp_vendor', 'none');
    }

    // Show release section
    setDisplay('.rls', 'block');

    // Handle closed status
    const updateBtn = content.querySelector('#b_update_lift');
    const releaseBtn = content.querySelector('#b_release_lift');
    const reminderBtn = content.querySelector('#b_set_reminder');
    const closedMsg = content.querySelector('#lift_closed');

    if (obj.CLOSED == 1) {
        [updateBtn, releaseBtn, reminderBtn].forEach(btn => {
            if (btn) btn.style.display = 'none';
        });
        if (closedMsg) closedMsg.innerHTML = "Lift Status is Closed";
    } else {
        [updateBtn, releaseBtn, reminderBtn].forEach(btn => {
            if (btn) btn.style.display = 'inline-block';
        });
        if (closedMsg) closedMsg.innerHTML = "";
    }

    // Add action buttons
    const buttonContainer = document.createElement('div');
    buttonContainer.className = 'button-container';

    const buttons = [
        { id: 'nl_btn_cancel', text: 'Cancel', icon: '✕', onClick: () => closeDialog() },
        { id: 'b_update_lift', text: 'Update Lift', icon: '💾', onClick: () => updateLift(obj) },
        { id: 'b_release_lift', text: 'Release Lift', icon: '📤', onClick: () => releaseLift(obj) },
        { id: 'b_set_reminder', text: 'Create Reminder', icon: '⏰', onClick: () => dspReminderDialog() }
    ];

    buttons.forEach(btn => {
        const button = document.createElement('button');
        button.id = btn.id;
        button.innerHTML = `${btn.icon} ${btn.text}`;
        button.className = 'action-button';
        button.onclick = btn.onClick;
        buttonContainer.appendChild(button);
    });

    dialog.appendChild(buttonContainer);

    // Close dialog function
    function closeDialog() {
        document.body.removeChild(backdrop);
        document.body.removeChild(dialog);
        const originalLiftInfo = document.getElementById('lift_info');
        if (originalLiftInfo) {
            originalLiftInfo.innerHTML = content.innerHTML;
        }
    }

    // Event listeners
    closeBtn.onclick = closeDialog;
    backdrop.onclick = closeDialog;

    // Handle escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeDialog();
        }
    });

    // Add dialog and backdrop to body
    document.body.appendChild(backdrop);
    document.body.appendChild(dialog);
}

function updateLift(obj) {
    let error = false;
    let _finalInvoiceAmt = 0;
    let _ProgressBilling = 0;

    // Helper function to get element value
    const getValue = (id) => {
        const element = document.getElementById(id);
        return element ? element.value : '';
    };

    // Helper function to focus element
    const focusElement = (id) => {
        const element = document.getElementById(id);
        if (element) element.focus();
    };

    // Helper function to trim value
    const trimValue = (id) => {
        return getValue(id).trim();
    };

    // Validation checks
    if (getValue('lift_company') === '') {
        error = true;
        alert('Please select the lift company.');
        focusElement('lift_company');
        return;
    }

    if (getValue('lift_company') === 'FieldTech' && getValue('lift_vendor') === '') {
        error = true;
        alert('Please select the lift vendor company.');
        focusElement('lift_vendor');
        return;
    }

    if (getValue('equipmenttype') === '') {
        error = true;
        alert('Please select the equipment type.');
        focusElement('equipmenttype');
        return;
    }

    const hasReleaseInfo = trimValue('rls_date') !== '' || 
                         trimValue('release_with') !== '' || 
                         trimValue('release_number') !== '';

    if (hasReleaseInfo) {
        if (trimValue('rls_date') === '') {
            error = true;
            alert('The release date is required.');
            focusElement('rls_date');
            return;
        }

        if (trimValue('release_with') === '') {
            error = true;
            alert('Release with is required.');
            focusElement('release_with');
            return;
        }

        if (trimValue('release_number') === '' || trimValue('release_number') === '0') {
            error = true;
            alert('The release number is required.');
            focusElement('release_number');
            return;
        }
    }

    if (trimValue('qty') === '') {
        error = true;
        alert('Please enter the quantity.');
        focusElement('qty');
        return;
    }

    if (trimValue('est_cost') === '' || Number(trimValue('est_cost')) === 0) {
        error = true;
        alert('Please select the estimated cost.');
        focusElement('est_cost');
        return;
    }

    if (trimValue('conf_number') === '') {
        error = true;
        alert('Please select the confirmation number.');
        focusElement('conf_number');
        return;
    }

    if (trimValue('end_date') === '') {
        error = true;
        alert('Please select the end date.');
        focusElement('end_date');
        return;
    }

    // Get estimated cost
    const _estCost = trimValue('est_cost') === '' ? 0 : getValue('est_cost');

    // Get final invoice amount
    const finalInvoiceAmtValue = trimValue('final_invoice_amt');
    if (finalInvoiceAmtValue === '' || isNaN(Number(finalInvoiceAmtValue))) {
        _finalInvoiceAmt = 0;
    } else {
        _finalInvoiceAmt = finalInvoiceAmtValue;
    }

    // Check progress billing
    const progressBillingCheckbox = document.getElementById('cbProgressBilling');
    if (progressBillingCheckbox?.checked) {
        _ProgressBilling = 1;
    }

    let thisLiftComp = '';
    let _isFieldTech = 0;
    let liftVendorID = '';

    // Get lift company info
    const liftCompanySelect = document.getElementById('lift_company');
    const liftVendorSelect = document.getElementById('lift_vendor');

    if (getValue('lift_company') === 'FieldTech') {
        _isFieldTech = 1;
        thisLiftComp = getValue('lift_vendor');
        if (liftVendorSelect?.options[liftVendorSelect.selectedIndex]) {
            liftVendorID = liftVendorSelect.options[liftVendorSelect.selectedIndex].getAttribute('data-liftvendorid');
        }
    } else {
        thisLiftComp = getValue('lift_company');
        if (liftCompanySelect && liftCompanySelect.options && liftCompanySelect.selectedIndex >= 0) {
            const selectedOption = liftCompanySelect.options[liftCompanySelect.selectedIndex];
            if (selectedOption) {
                liftVendorID = selectedOption.getAttribute('data-liftvendorid');
            }
        }
    }

    if (!error) {
        const formData = {
            id: obj.ID,
            order_id: orderId,
            quantity: getValue('qty'),
            estimatedcost: _estCost,
            notes: getValue('notes'),
            confirmationnumber: getValue('conf_number'),
            releasenumber: getValue('release_number'),
            closeout: getValue('closeout'),
            enddate: getValue('end_date'),
            releasedate: getValue('rls_date'),
            liftcompany: thisLiftComp,
            liftvendorid: liftVendorID,
            isFieldTech: _isFieldTech,
            releasewith: getValue('release_with'),
            finalinvoiceamount: _finalInvoiceAmt,
            ProgressBilling: _ProgressBilling,
            invoicenumber: getValue('invoice_number'),
            equipmenttype: getValue('equipmenttype'),
            deliverydate: getValue('delivery_date')
        };

        // Make the AJAX request using fetch
        fetch('lifts.cfc?method=editLift&returnformat=json', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData),
            cache: 'no-store'
        })
        .then(response => response.json())
        .then(response => {
            alert(response.MESSAGE);
            if (!response.ERROR) {
                const cancelBtn = document.getElementById('nl_btn_cancel');
                if (cancelBtn) cancelBtn.click();
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('An error occurred while updating the lift');
        });
    }
}

function displayPhone(p) {
    // Get elements from both the original form and modal dialog
    const disp_vendor = document.getElementById('disp_vendor');
    const lift_phone = document.getElementById('lift_phone');
    const lift_vendor = document.getElementById('lift_vendor');
    const lift_company = document.getElementById('lift_company');

    // Helper function to update phone display
    const updatePhoneDisplay = (phoneElement, phone, acctno, webURL) => {
        if (!phoneElement) return;
        
        if (phone || acctno || webURL) {
            let liftInfo = '';
            if (phone) liftInfo += `Phone: ${phone}<br>`;
            if (acctno) liftInfo += `Account #: ${acctno}<br>`;
            if (webURL) liftInfo += `<a href='${webURL}' target='_blank'>${webURL}</a>`;
            phoneElement.innerHTML = liftInfo;
        } else {
            phoneElement.innerHTML = '';
        }
    };

    // Clear phone displays
    if (lift_phone) lift_phone.innerHTML = '';
    const modalLiftPhone = document.querySelector('.modal-dialog #lift_phone');
    if (modalLiftPhone) modalLiftPhone.innerHTML = '';

    // Reset vendor value
    if (lift_vendor) {
        lift_vendor.value = '';
        const event = new Event('change');
        lift_vendor.dispatchEvent(event);
    }

    // Handle vendor display visibility
    if (disp_vendor) {
        // Force reflow
        disp_vendor.style.cssText = 'display: none !important';
        disp_vendor.classList.remove('hidden');
        
        if (p === "FieldTech") {
            // Show vendor dropdown for FieldTech
            disp_vendor.style.cssText = 'display: table-row !important';
            disp_vendor.classList.remove('hidden');
        } else {
            // Hide vendor dropdown for all other cases
            disp_vendor.style.cssText = 'display: none !important';
            disp_vendor.classList.add('hidden');
        }
    }

    // If no value or FieldTech selected, return early
    if (!p || p === "" || p === "FieldTech") {
        return;
    }

    // Handle regular lift company selection
    if (lift_company && lift_company.options) {
        const selectedOption = Array.from(lift_company.options).find(option => option.value === p);
        
        if (selectedOption) {
            const phone = selectedOption.dataset.phone || '';
            const acctno = selectedOption.dataset.acctno || '';
            const webURL = selectedOption.dataset.weburl || '';
            
            // Update phone displays
            updatePhoneDisplay(lift_phone, phone, acctno, webURL);
            if (modalLiftPhone) {
                updatePhoneDisplay(modalLiftPhone, phone, acctno, webURL);
            }
        }
    }
} 