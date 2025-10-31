package com.chiro.erp.platform.identity.infrastructure.persistence

import com.chiro.erp.platform.identity.domain.models.User
import com.chiro.erp.platform.identity.domain.ports.outbound.UserRepository
import io.quarkus.hibernate.reactive.panache.kotlin.PanacheRepositoryBase
import io.smallrye.mutiny.coroutines.awaitSuspending
import jakarta.enterprise.context.ApplicationScoped
import java.util.*

/**
 * Reactive Panache repository implementation for User
 */
@ApplicationScoped
class UserRepositoryImpl : PanacheRepositoryBase<User, UUID>, UserRepository {

    override suspend fun save(user: User): User {
        return if (user.id != null && findById(user.id).awaitSuspending() != null) {
            getEntityManager().merge(user).awaitSuspending()
        } else {
            persist(user).awaitSuspending()
        }
    }

    override suspend fun findById(id: UUID): User? {
        return findById(id).awaitSuspending()
    }

    override suspend fun findByUsername(username: String): User? {
        return find("username", username).firstResult<User>().awaitSuspending()
    }

    override suspend fun findByEmail(email: String): User? {
        return find("email", email).firstResult<User>().awaitSuspending()
    }

    override suspend fun findByTenantId(tenantId: UUID, page: Int, size: Int): List<User> {
        return find("tenantId", tenantId)
            .page(page, size)
            .list<User>()
            .awaitSuspending()
    }

    override suspend fun existsByUsername(username: String): Boolean {
        return count("username", username).awaitSuspending() > 0
    }

    override suspend fun existsByEmail(email: String): Boolean {
        return count("email", email).awaitSuspending() > 0
    }

    override suspend fun delete(id: UUID) {
        deleteById(id).awaitSuspending()
    }

    override suspend fun count(): Long {
        return count().awaitSuspending()
    }
}
