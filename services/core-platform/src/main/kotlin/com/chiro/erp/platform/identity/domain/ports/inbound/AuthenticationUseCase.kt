package com.chiro.erp.platform.identity.domain.ports.inbound

import com.chiro.erp.platform.identity.domain.models.User
import java.util.*

/**
 * Inbound port for authentication use cases
 */
interface AuthenticationUseCase {
    
    suspend fun authenticate(command: AuthenticateCommand): AuthenticationResult
    suspend fun refreshToken(refreshToken: String): AuthenticationResult
    suspend fun logout(userId: UUID)
    suspend fun changePassword(command: ChangePasswordCommand)
    suspend fun resetPassword(email: String): String // Returns reset token
    suspend fun confirmPasswordReset(command: ConfirmPasswordResetCommand)
}

/**
 * Commands for authentication operations
 */
data class AuthenticateCommand(
    val username: String,
    val password: String,
    val tenantId: UUID? = null
)

data class ChangePasswordCommand(
    val userId: UUID,
    val currentPassword: String,
    val newPassword: String
)

data class ConfirmPasswordResetCommand(
    val resetToken: String,
    val newPassword: String
)

/**
 * Authentication result
 */
data class AuthenticationResult(
    val user: User,
    val accessToken: String,
    val refreshToken: String,
    val expiresIn: Long // seconds
)
