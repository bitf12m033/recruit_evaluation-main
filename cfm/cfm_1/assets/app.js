// DOM Elements
const addLiftBtn = document.getElementById('add_lift_btn');
const liftModal = document.getElementById('lift_modal');
const closeModalBtn = document.querySelector('.close-modal');
const cancelBtn = document.getElementById('cancel_btn');
const liftForm = document.getElementById('lift_form');
const modalTitle = document.getElementById('modal_title');

// State
let currentLiftId = null;
let isLoading = false;

// Event Listeners
document.addEventListener('DOMContentLoaded', () => {
    setupEventListeners();
    setupTableEventListeners();
});

// Setup Functions
function setupEventListeners() {
    addLiftBtn.addEventListener('click', () => showModal('Add New Lift'));
    closeModalBtn.addEventListener('click', hideModal);
    cancelBtn.addEventListener('click', hideModal);
    liftForm.addEventListener('submit', handleFormSubmit);
}

function setupTableEventListeners() {
    document.querySelectorAll('.btn-edit').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const liftId = e.target.dataset.liftId;
            editLift(liftId);
        });
    });

    document.querySelectorAll('.btn-delete').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const liftId = e.target.dataset.liftId;
            deleteLift(liftId);
        });
    });
}

// Modal Functions
function showModal(title) {
    modalTitle.textContent = title;
    liftModal.style.display = 'block';
    currentLiftId = null;
    liftForm.reset();
}

function hideModal() {
    liftModal.style.display = 'none';
    currentLiftId = null;
    liftForm.reset();
    clearErrors();
}

// Form Handling
async function handleFormSubmit(e) {
    e.preventDefault();
    
    if (!validateForm()) {
        return;
    }

    if (isLoading) return;
    setLoading(true);

    const formData = new FormData(liftForm);
    const data = Object.fromEntries(formData.entries());

    try {
        const response = await saveLift(data);
        if (response.success) {
            showSuccess('Lift saved successfully');
            hideModal();
            location.reload(); // Refresh to show updated data
        } else {
            showError(response.message || 'Failed to save lift');
        }
    } catch (error) {
        showError('An error occurred while saving the lift');
        console.error('Error saving lift:', error);
    } finally {
        setLoading(false);
    }
}

function validateForm() {
    const requiredFields = ['lift_company', 'equipment_type', 'delivery_date', 'estimated_cost', 'quantity'];
    let isValid = true;

    clearErrors();

    requiredFields.forEach(field => {
        const input = document.getElementById(field);
        if (!input.value.trim()) {
            isValid = false;
            showFieldError(input, 'This field is required');
        } else {
            input.classList.remove('error');
        }
    });

    // Validate numeric fields
    const estimatedCost = document.getElementById('estimated_cost');
    const quantity = document.getElementById('quantity');

    if (estimatedCost.value && isNaN(estimatedCost.value) || estimatedCost.value < 0) {
        isValid = false;
        showFieldError(estimatedCost, 'Please enter a valid cost');
    }

    if (quantity.value && (isNaN(quantity.value) || quantity.value < 1)) {
        isValid = false;
        showFieldError(quantity, 'Please enter a valid quantity (minimum 1)');
    }

    if (!isValid) {
        showError('Please correct the errors before submitting');
    }

    return isValid;
}

// API Calls
async function editLift(liftId) {
    if (isLoading) return;
    setLoading(true);

    try {
        const response = await fetch(`lifts.cfc?method=getLiftInfo&returnformat=json`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ liftid: liftId })
        });

        const data = await response.json();
        if (data.success) {
            currentLiftId = liftId;
            populateForm(data.data);
            showModal('Edit Lift');
        } else {
            showError(data.message || 'Failed to load lift data');
        }
    } catch (error) {
        showError('Failed to load lift data');
        console.error('Error loading lift:', error);
    } finally {
        setLoading(false);
    }
}

async function saveLift(data) {
    try {
        const response = await fetch(`lifts.cfc?method=editLift&returnformat=json`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                id: currentLiftId,
                ...data
            })
        });

        return await response.json();
    } catch (error) {
        throw error;
    }
}

async function deleteLift(liftId) {
    if (!confirm('Are you sure you want to delete this lift? This action cannot be undone.')) {
        return;
    }

    if (isLoading) return;
    setLoading(true);

    try {
        const response = await fetch(`lifts.cfc?method=deleteLift&returnformat=json`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ liftid: liftId })
        });

        const data = await response.json();
        if (data.success) {
            showSuccess('Lift deleted successfully');
            location.reload(); // Refresh to show updated data
        } else {
            showError(data.message || 'Failed to delete lift');
        }
    } catch (error) {
        showError('An error occurred while deleting the lift');
        console.error('Error deleting lift:', error);
    } finally {
        setLoading(false);
    }
}

// Helper Functions
function populateForm(data) {
    document.getElementById('lift_company').value = data.liftcompany || '';
    document.getElementById('equipment_type').value = data.equipmenttype || '';
    document.getElementById('delivery_date').value = formatDate(data.deliverydate);
    document.getElementById('estimated_cost').value = data.estimatedcost || '';
    document.getElementById('quantity').value = data.qty || '';
    document.getElementById('notes').value = data.notes || '';
}

function formatDate(dateString) {
    if (!dateString) return '';
    const date = new Date(dateString);
    return date.toISOString().split('T')[0];
}

// UI Helper Functions
function setLoading(loading) {
    isLoading = loading;
    const submitBtn = liftForm.querySelector('button[type="submit"]');
    const cancelBtn = document.getElementById('cancel_btn');
    
    if (loading) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner"></span> Saving...';
        cancelBtn.disabled = true;
    } else {
        submitBtn.disabled = false;
        submitBtn.textContent = 'Save';
        cancelBtn.disabled = false;
    }
}

function showError(message) {
    const errorDiv = document.createElement('div');
    errorDiv.className = 'alert alert-error';
    errorDiv.textContent = message;
    
    const formActions = liftForm.querySelector('.form-actions');
    liftForm.insertBefore(errorDiv, formActions);
    
    setTimeout(() => {
        errorDiv.remove();
    }, 5000);
}

function showSuccess(message) {
    const successDiv = document.createElement('div');
    successDiv.className = 'alert alert-success';
    successDiv.textContent = message;
    
    const formActions = liftForm.querySelector('.form-actions');
    liftForm.insertBefore(successDiv, formActions);
    
    setTimeout(() => {
        successDiv.remove();
    }, 5000);
}

function showFieldError(input, message) {
    input.classList.add('error');
    const errorDiv = document.createElement('div');
    errorDiv.className = 'field-error';
    errorDiv.textContent = message;
    input.parentNode.appendChild(errorDiv);
}

function clearErrors() {
    // Clear field errors
    document.querySelectorAll('.field-error').forEach(error => error.remove());
    document.querySelectorAll('.error').forEach(input => input.classList.remove('error'));
    
    // Clear form alerts
    document.querySelectorAll('.alert').forEach(alert => alert.remove());
} 