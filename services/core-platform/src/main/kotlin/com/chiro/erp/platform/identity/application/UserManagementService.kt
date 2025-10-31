package com.chiro.erp.platform.identity.application

import com.chiro.erp.platform.identity.domain.models.User
import com.chiro.erp.platform.identity.domain.models.UserStatus
import com.chiro.erp.platform.identity.domain.ports.inbound.UserManagementUseCase
import com.chiro.erp.platform.identity.domain.ports.inbound.CreateUserCommand
import com.chiro.erp.platform.identity.domain.ports.inbound.UpdateUserCommand
import com.chiro.erp.platform.identity.domain.ports.outbound.UserRepository
import com.chiro.erp.platform.identity.domain.ports.outbound.PasswordEncoder
import com.chiro.erp.platform.identity.domain.ports.outbound.IdentityEventPublisher
import jakarta.enterprise.context.ApplicationScoped
import jakarta.inject.Inject
import java.time.Instant
import java.util.*

/**
 * Application service implementing user management use cases
 */
@ApplicationScoped
class UserManagementService @Inject constructor(
    private val userRepository: UserRepository,
    private val passwordEncoder: PasswordEncoder,
    private val eventPublisher: IdentityEventPublisher
) : UserManagementUseCase {

    override suspend fun createUser(command: CreateUserCommand): User {
        // Validate username and email are unique
        if (userRepository.existsByUsername(command.username)) {
            throw IllegalArgumentException("Username already exists: ${command.username}")
        }
        
        if (userRepository.existsByEmail(command.email)) {
            throw IllegalArgumentException("Email already exists: ${command.email}")
        }

        // Create user entity
        val user = User(
            username = command.username,
            email = command.email,
            passwordHash = passwordEncoder.encode(command.password),
            firstName = command.firstName,
            lastName = command.lastName,
            tenantId = command.tenantId,
            status = UserStatus.ACTIVE
        )

        // Save user
        val savedUser = userRepository.save(user)

        // Publish domain event
        eventPublisher.publishUserCreated(
            userId = savedUser.id.toString(),
            tenantId = savedUser.tenantId.toString(),
            username = savedUser.username
        )

        return savedUser
    }

    override suspend fun updateUser(userId: UUID, command: UpdateUserCommand): User {
        val existingUser = userRepository.findById(userId)
            ?: throw IllegalArgumentException("User not found: $userId")

        val updatedUser = existingUser.copy(
            firstName = command.firstName ?: existingUser.firstName,
            lastName = command.lastName ?: existingUser.lastName,
            email = command.email ?: existingUser.email,
            updatedAt = Instant.now()
        )

        val savedUser = userRepository.save(updatedUser)

        // Publish domain event
        val changes = mutableMapOf<String, Any?>()
        if (command.firstName != null) changes["firstName"] = command.firstName
        if (command.lastName != null) changes["lastName"] = command.lastName
        if (command.email != null) changes["email"] = command.email
        
        eventPublisher.publishUserUpdated(
            userId = savedUser.id.toString(),
            tenantId = savedUser.tenantId.toString(),
            changes = changes
        )

        return savedUser
    }

    override suspend fun deleteUser(userId: UUID) {
        val user = userRepository.findById(userId)
            ?: throw IllegalArgumentException("User not found: $userId")
        
        userRepository.delete(userId)
    }

    override suspend fun getUserById(userId: UUID): User? {
        return userRepository.findById(userId)
    }

    override suspend fun getUserByUsername(username: String): User? {
        return userRepository.findByUsername(username)
    }

    override suspend fun getUserByEmail(email: String): User? {
        return userRepository.findByEmail(email)
    }

    override suspend fun getAllUsers(tenantId: UUID, page: Int, size: Int): List<User> {
        return userRepository.findByTenantId(tenantId, page, size)
    }

    override suspend fun activateUser(userId: UUID): User {
        val user = userRepository.findById(userId)
            ?: throw IllegalArgumentException("User not found: $userId")
        
        val activatedUser = user.copy(
            status = UserStatus.ACTIVE,
            updatedAt = Instant.now()
        )
        
        return userRepository.save(activatedUser)
    }

    override suspend fun deactivateUser(userId: UUID): User {
        val user = userRepository.findById(userId)
            ?: throw IllegalArgumentException("User not found: $userId")
        
        val deactivatedUser = user.copy(
            status = UserStatus.INACTIVE,
            updatedAt = Instant.now()
        )
        
        return userRepository.save(deactivatedUser)
    }
}
