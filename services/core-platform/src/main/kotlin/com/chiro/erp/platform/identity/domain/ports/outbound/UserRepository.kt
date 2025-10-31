package com.chiro.erp.platform.identity.domain.ports.outbound

import com.chiro.erp.platform.identity.domain.models.User
import java.util.*

/**
 * Outbound port for user repository
 */
interface UserRepository {
    
    suspend fun save(user: User): User
    suspend fun findById(id: UUID): User?
    suspend fun findByUsername(username: String): User?
    suspend fun findByEmail(email: String): User?
    suspend fun findByTenantId(tenantId: UUID, page: Int = 0, size: Int = 20): List<User>
    suspend fun existsByUsername(username: String): Boolean
    suspend fun existsByEmail(email: String): Boolean
    suspend fun delete(id: UUID)
    suspend fun count(): Long
}
