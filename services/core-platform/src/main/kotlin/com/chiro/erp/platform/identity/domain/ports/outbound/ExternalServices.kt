package com.chiro.erp.platform.identity.domain.ports.outbound

/**
 * Outbound port for password encryption
 */
interface PasswordEncoder {
    fun encode(rawPassword: String): String
    fun matches(rawPassword: String, encodedPassword: String): Boolean
}

/**
 * Outbound port for JWT token management
 */
interface TokenService {
    fun generateAccessToken(userId: String, username: String, roles: List<String>): String
    fun generateRefreshToken(userId: String): String
    fun validateToken(token: String): Boolean
    fun extractUserId(token: String): String?
    fun extractUsername(token: String): String?
    fun extractRoles(token: String): List<String>
}

/**
 * Outbound port for event publishing
 */
interface IdentityEventPublisher {
    suspend fun publishUserCreated(userId: String, tenantId: String, username: String)
    suspend fun publishUserUpdated(userId: String, tenantId: String, changes: Map<String, Any?>)
    suspend fun publishUserAuthenticated(userId: String, tenantId: String, timestamp: Long)
    suspend fun publishPasswordChanged(userId: String, tenantId: String)
}
