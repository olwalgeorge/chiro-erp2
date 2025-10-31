package com.chiro.erp.platform.identity.interfaces.rest

import com.chiro.erp.platform.identity.domain.models.User
import java.time.Instant
import java.util.*

/**
 * Request/Response DTOs for User REST API
 */
data class CreateUserRequest(
    val username: String,
    val email: String,
    val password: String,
    val firstName: String,
    val lastName: String,
    val tenantId: UUID,
    val roleIds: Set<UUID> = emptySet()
)

data class UpdateUserRequest(
    val firstName: String? = null,
    val lastName: String? = null,
    val email: String? = null,
    val roleIds: Set<UUID>? = null
)

data class UserResponse(
    val id: UUID,
    val username: String,
    val email: String,
    val firstName: String,
    val lastName: String,
    val fullName: String,
    val status: String,
    val tenantId: UUID,
    val roles: Set<RoleResponse>,
    val createdAt: Instant,
    val updatedAt: Instant
) {
    companion object {
        fun from(user: User): UserResponse = UserResponse(
            id = user.id,
            username = user.username,
            email = user.email,
            firstName = user.firstName,
            lastName = user.lastName,
            fullName = user.getFullName(),
            status = user.status.name,
            tenantId = user.tenantId,
            roles = user.roles.map { RoleResponse.from(it) }.toSet(),
            createdAt = user.createdAt,
            updatedAt = user.updatedAt
        )
    }
}

data class RoleResponse(
    val id: UUID,
    val name: String,
    val description: String?
) {
    companion object {
        fun from(role: com.chiro.erp.platform.identity.domain.models.Role): RoleResponse = 
            RoleResponse(
                id = role.id,
                name = role.name,
                description = role.description
            )
    }
}
