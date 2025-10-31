package com.chiro.erp.platform.identity.domain.ports.inbound

import com.chiro.erp.platform.identity.domain.models.User
import java.util.*

/**
 * Inbound port for user management use cases
 */
interface UserManagementUseCase {
    
    suspend fun createUser(command: CreateUserCommand): User
    suspend fun updateUser(userId: UUID, command: UpdateUserCommand): User
    suspend fun deleteUser(userId: UUID)
    suspend fun getUserById(userId: UUID): User?
    suspend fun getUserByUsername(username: String): User?
    suspend fun getUserByEmail(email: String): User?
    suspend fun getAllUsers(tenantId: UUID, page: Int = 0, size: Int = 20): List<User>
    suspend fun activateUser(userId: UUID): User
    suspend fun deactivateUser(userId: UUID): User
}

/**
 * Commands for user operations
 */
data class CreateUserCommand(
    val username: String,
    val email: String,
    val password: String,
    val firstName: String,
    val lastName: String,
    val tenantId: UUID,
    val roleIds: Set<UUID> = emptySet()
)

data class UpdateUserCommand(
    val firstName: String? = null,
    val lastName: String? = null,
    val email: String? = null,
    val roleIds: Set<UUID>? = null
)
