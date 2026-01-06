$(document).ready(function () {

    /* =======================
       DROPDOWN LOGIC
    ======================= */
    function closeAllMenus() {
        $('.dropdown-container div[id$="Menu"]')
            .addClass('hidden')
            .removeClass('show-menu');
    }

    function setupDropdown(btnId, menuId) {
        $(btnId).on('click', function (e) {
            e.stopPropagation();
            const menu = $(menuId);
            const isShowing = !menu.hasClass('hidden');
            closeAllMenus();
            if (!isShowing) {
                menu.removeClass('hidden').addClass('show-menu');
            }
        });
    }

    setupDropdown('#shopDropdownBtn', '#shopDropdownMenu');
    setupDropdown('#chatDropdownBtn', '#chatDropdownMenu');

    $(document).on('click', function () {
        closeAllMenus();
    });

    $('#chatDropdownMenu').on('click', function (e) {
        e.stopPropagation();
    });

    /* =======================
       SIDEBAR TOGGLE LOGIC
    ======================= */
    const $sidebar = $('#rightSidebar');
    const $texts = $('.sidebar-text');

    $('#toggleSidebarBtn').on('click', function (e) {
        e.stopPropagation();
        const isCollapsed = $sidebar.hasClass('w-20');

        if (isCollapsed) {
            $sidebar.removeClass('w-20').addClass('w-64');
            $texts.removeClass('hidden').addClass('inline');
        } else {
            $sidebar.removeClass('w-64').addClass('w-20');
            $texts.addClass('hidden').removeClass('inline');
        }
    });
	
	let isOpen = true;
	$('#toggleSidebarBtn').on('click', function () {
	    isOpen = !isOpen;
	    $('#sidebarIcon')
	        .toggleClass('fa-chevron-left', isOpen)
	        .toggleClass('fa-chevron-right', !isOpen);
	});

});

/* =======================
   LOGOUT LOGIC
======================= */
function handleLogout() {
    // Sử dụng SweetAlert2 để thông báo chuyên nghiệp
    Swal.fire({
        title: 'Bạn muốn đăng xuất?',
        text: "Hệ thống sẽ kết thúc phiên làm việc của bạn!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#00B14F', // Màu xanh NGHV
        cancelButtonColor: '#d33',
        confirmButtonText: 'Đăng xuất',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            // Thông báo đang xử lý
            Swal.fire({
                title: 'Đang đăng xuất...',
                html: 'Vui lòng chờ trong giây lát.',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            // Gọi URL đăng xuất sau 1 giây để người dùng kịp thấy thông báo
            setTimeout(() => {
                window.location.href = '/auth/logout';
            }, 1000);
        }
    });
}