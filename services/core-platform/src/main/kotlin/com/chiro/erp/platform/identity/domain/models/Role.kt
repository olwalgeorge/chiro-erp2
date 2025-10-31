package com.chiro.erp.platform.identity.domain.models

import jakarta.persistence.*
import java.util.*

/**
 * Role domain entity for RBAC
 */
@Entity
@Table(name = "roles")
data class Role(
    @Id
    val id: UUID = UUID.randomUUID(),
    
    @Column(unique = true, nullable = false)
    val name: String,
    
    val description: String? = null,
    
    // Multi-tenancy support
    val tenantId: UUID? = null, // null for global roles
    
    // Role permissions (many-to-many relationship)
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "role_permissions",
        joinColumns = [JoinColumn(name = "role_id")],
        inverseJoinColumns = [JoinColumn(name = "permission_id")]
    )
    val permissions: Set<Permission> = emptySet()
) {
    fun hasPermission(permissionName: String): Boolean =
        permissions.any { it.name.equals(permissionName, ignoreCase = true) }
}

/**
 * Permission domain entity
 */
@Entity
@Table(name = "permissions")
data class Permission(
    @Id
    val id: UUID = UUID.randomUUID(),
    
    @Column(unique = true, nullable = false)
    val name: String,
    
    val description: String? = null,
    
    val resource: String, // e.g., "user", "order", "product"
    val action: String    // e.g., "read", "write", "delete"
)
