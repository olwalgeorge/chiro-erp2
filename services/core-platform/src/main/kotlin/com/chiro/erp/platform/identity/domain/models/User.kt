package com.chiro.erp.platform.identity.domain.models

import jakarta.persistence.*
import java.time.Instant
import java.util.*

/**
 * User domain entity representing a system user
 */
@Entity
@Table(name = "users")
data class User(
    @Id
    val id: UUID = UUID.randomUUID(),
    
    @Column(unique = true, nullable = false)
    val username: String,
    
    @Column(unique = true, nullable = false) 
    val email: String,
    
    @Column(nullable = false)
    val passwordHash: String,
    
    val firstName: String,
    val lastName: String,
    
    @Enumerated(EnumType.STRING)
    val status: UserStatus = UserStatus.ACTIVE,
    
    val createdAt: Instant = Instant.now(),
    val updatedAt: Instant = Instant.now(),
    
    // Multi-tenancy support
    val tenantId: UUID,
    
    // User roles (many-to-many relationship)
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "user_roles",
        joinColumns = [JoinColumn(name = "user_id")],
        inverseJoinColumns = [JoinColumn(name = "role_id")]
    )
    val roles: Set<Role> = emptySet()
) {
    fun getFullName(): String = "$firstName $lastName"
    
    fun hasRole(roleName: String): Boolean = 
        roles.any { it.name.equals(roleName, ignoreCase = true) }
    
    fun isActive(): Boolean = status == UserStatus.ACTIVE
}

enum class UserStatus {
    ACTIVE, INACTIVE, SUSPENDED, PENDING_VERIFICATION
}
