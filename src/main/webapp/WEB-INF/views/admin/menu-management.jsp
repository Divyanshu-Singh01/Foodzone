<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Menu Catalog Management - FoodZone Admin" />
<c:set var="activeAdminTab" value="menu" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<main class="container">
    <div class="admin-grid">
        <!-- Admin Sidebar Navigation -->
        <aside class="admin-sidebar">
            <div style="padding-bottom: 16px; margin-bottom: 16px; border-bottom: 1px solid var(--gray-200);">
                <span style="font-size: 0.75rem; text-transform: uppercase; font-weight: 700; color: var(--gray-600); letter-spacing: 0.05em;">Management Console</span>
                <h3 style="font-size: 1.1rem; margin-top: 4px;">Admin Portal</h3>
            </div>
            <ul class="admin-nav">
                <li>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fa-solid fa-chart-pie"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/menu" class="active">
                        <i class="fa-solid fa-burger"></i> Menu Catalog
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/orders">
                        <i class="fa-solid fa-clipboard-list"></i> Live Orders
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/users">
                        <i class="fa-solid fa-users"></i> Customers
                    </a>
                </li>
            </ul>
        </aside>

        <!-- Main Content Area -->
        <section>
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                <div>
                    <span style="color: var(--primary); font-weight: 700; font-size: 0.85rem; text-transform: uppercase;">Dish Catalog</span>
                    <h1 style="font-size: 2rem; margin-top: 2px;">Menu Management</h1>
                </div>
            </div>

            <!-- Success Notification -->
            <c:if test="${param.msg == 'success'}">
                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i> Menu changes successfully saved to database.
                </div>
            </c:if>

            <!-- Add / Edit Item Card -->
            <div style="background: var(--white); border-radius: var(--radius-lg); border: 1.5px solid ${not empty editItem ? 'var(--primary)' : 'var(--gray-200)'}; padding: 24px; margin-bottom: 32px; box-shadow: var(--shadow-sm);">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; border-bottom: 1px solid var(--gray-200); padding-bottom: 12px;">
                    <h2 style="font-size: 1.25rem; color: ${not empty editItem ? 'var(--primary)' : 'var(--dark)'};">
                        <i class="fa-solid ${not empty editItem ? 'fa-pen-to-square' : 'fa-plus'}"></i>
                        ${not empty editItem ? 'Edit Food Item #'.concat(editItem.foodId) : 'Add New Food Item'}
                    </h2>
                    <c:if test="${not empty editItem}">
                        <a href="${pageContext.request.contextPath}/admin/menu" class="btn btn-secondary btn-sm">
                            <i class="fa-solid fa-xmark"></i> Cancel Edit
                        </a>
                    </c:if>
                </div>

                <form action="${pageContext.request.contextPath}/admin/menu" method="post">
                    <input type="hidden" name="action" value="${not empty editItem ? 'update' : 'add'}">
                    <c:if test="${not empty editItem}">
                        <input type="hidden" name="foodId" value="${editItem.foodId}">
                    </c:if>

                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 18px;">
                        <div class="form-group">
                            <label class="form-label">Dish Name <span style="color: var(--danger);">*</span></label>
                            <input type="text" name="foodName" class="form-control" required placeholder="e.g. Paneer Tikka Pizza"
                                   value="<c:out value='${editItem != null ? editItem.foodName : ""}'/>">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Category <span style="color: var(--danger);">*</span></label>
                            <select name="categoryId" class="form-control" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}" ${editItem != null and editItem.categoryId == cat.categoryId ? 'selected' : ''}>
                                        ${cat.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Price (₹) <span style="color: var(--danger);">*</span></label>
                            <input type="number" step="0.01" min="0" name="price" class="form-control" required placeholder="249.00"
                                   value="${editItem != null ? editItem.price : ''}">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Image URL</label>
                            <input type="url" name="imageUrl" class="form-control" placeholder="https://images.unsplash.com/..."
                                   value="<c:out value='${editItem != null ? editItem.imageUrl : ""}'/>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control" rows="2" placeholder="Brief tempting description of taste and ingredients"><c:out value="${editItem != null ? editItem.description : ''}"/></textarea>
                    </div>

                    <div style="display: flex; gap: 24px; align-items: center; margin-top: 10px; margin-bottom: 20px;">
                        <label style="display: inline-flex; align-items: center; gap: 8px; cursor: pointer; font-size: 0.95rem; font-weight: 600;">
                            <input type="checkbox" name="isVeg" value="true" ${editItem == null or editItem.veg ? 'checked' : ''} style="width: 18px; height: 18px; accent-color: var(--secondary);">
                            <span style="color: #047857;">Vegetarian Dish</span>
                        </label>

                        <label style="display: inline-flex; align-items: center; gap: 8px; cursor: pointer; font-size: 0.95rem; font-weight: 600;">
                            <input type="checkbox" name="isAvailable" value="true" ${editItem == null or editItem.available ? 'checked' : ''} style="width: 18px; height: 18px; accent-color: var(--primary);">
                            <span>In Stock / Available for Order</span>
                        </label>
                    </div>

                    <button type="submit" class="btn btn-primary" style="padding: 10px 24px;">
                        <i class="fa-solid fa-check"></i> ${not empty editItem ? 'Update Food Item' : 'Add Dish to Menu'}
                    </button>
                </form>
            </div>

            <!-- Existing Food Items Table -->
            <div style="background: var(--white); border-radius: var(--radius-lg); border: 1px solid var(--gray-200); padding: 24px; box-shadow: var(--shadow-sm);">
                <h2 style="font-size: 1.25rem; margin-bottom: 18px;">All Menu Dishes (${items.size()})</h2>

                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Photo</th>
                                <th>Dish Name & Category</th>
                                <th>Type</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th style="text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${items}">
                                <tr>
                                    <td style="width: 60px;">
                                        <img src="${item.imageUrl}" alt="${item.foodName}" style="width: 52px; height: 52px; border-radius: var(--radius-sm); object-fit: cover;"
                                             onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600';">
                                    </td>
                                    <td>
                                        <div style="font-weight: 700; color: var(--dark);">${item.foodName}</div>
                                        <div style="font-size: 0.8rem; color: var(--gray-600);">${item.categoryName}</div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.veg}">
                                                <span style="display: inline-flex; align-items: center; gap: 6px; font-size: 0.82rem; font-weight: 700; color: #047857;">
                                                    <i class="fa-solid fa-circle" style="font-size: 0.6rem;"></i> Veg
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="display: inline-flex; align-items: center; gap: 6px; font-size: 0.82rem; font-weight: 700; color: #B91C1C;">
                                                    <i class="fa-solid fa-circle" style="font-size: 0.6rem;"></i> Non-Veg
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="font-weight: 700;">
                                        ₹<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.available}">
                                                <span class="badge badge-completed">In Stock</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-cancelled">Sold Out</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: right; white-space: nowrap;">
                                        <a href="${pageContext.request.contextPath}/admin/menu?editId=${item.foodId}" class="btn btn-outline btn-sm" title="Edit Item">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>

                                        <form action="${pageContext.request.contextPath}/admin/menu" method="post" style="display: inline-block; margin: 0;"
                                              onsubmit="return confirm('Are you sure you want to delete this menu item?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="foodId" value="${item.foodId}">
                                            <button type="submit" class="btn btn-danger btn-sm" style="padding: 6px 10px;" title="Delete Item">
                                                <i class="fa-regular fa-trash-can"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
