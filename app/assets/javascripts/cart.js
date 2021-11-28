function editReview(reviewUser) {
    const hiddenReviewContainer = document.querySelectorAll(".review-edit-container", `[data-user='${reviewUser}']`);
    Array.prototype.forEach.call(hiddenReviewContainer, hiddenReview => {
        if (hiddenReview['dataset'].user.includes(reviewUser)) {
            hiddenReview.classList.remove('hidden');
            // hiddenReview.querySelector("[name='edit_cart_review[review]']").disabled = false;
            // hiddenReview.querySelector("[name='edit_cart_review[rating]']").disabled = false;
        }
    });
}

document.addEventListener("DOMContentLoaded", () => {
    let editReviewButtons = document.getElementsByClassName('edit-review-button');
    Array.prototype.forEach.call(editReviewButtons, editReviewBtn => {
        // Add onclick listener for each edit review button
        editReviewBtn.addEventListener('click', () => {
            editReview(editReviewBtn['dataset'].user);
        });
    });
});