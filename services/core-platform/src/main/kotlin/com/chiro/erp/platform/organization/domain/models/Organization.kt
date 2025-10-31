package com.chiro.erp.platform.organization.domain.models

import jakarta.persistence.*
import java.time.Instant
import java.util.*

/**
 * Organization (Tenant) domain entity
 */
@Entity
@Table(name = "organizations")
data class Organization(
    @Id
    val id: UUID = UUID.randomUUID(),
    
    @Column(unique = true, nullable = false)
    val code: String, // Unique tenant code
    
    val name: String,
    val displayName: String? = null,
    val description: String? = null,
    
    @Enumerated(EnumType.STRING)
    val status: OrganizationStatus = OrganizationStatus.ACTIVE,
    
    @Enumerated(EnumType.STRING)
    val type: OrganizationType = OrganizationType.ENTERPRISE,
    
    // Contact information
    val email: String? = null,
    val phone: String? = null,
    val website: String? = null,
    
    // Address
    @Embedded
    val address: Address? = null,
    
    // Subscription and limits
    val maxUsers: Int = 100,
    val subscriptionPlan: String = "basic",
    val subscriptionExpiresAt: Instant? = null,
    
    val createdAt: Instant = Instant.now(),
    val updatedAt: Instant = Instant.now(),
    
    // Parent organization for hierarchical organizations
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_organization_id")
    val parentOrganization: Organization? = null,
    
    // Settings as JSON
    @Column(columnDefinition = "jsonb")
    val settings: Map<String, Any> = emptyMap()
) {
    fun isActive(): Boolean = status == OrganizationStatus.ACTIVE
    fun isSubscriptionValid(): Boolean = 
        subscriptionExpiresAt?.isAfter(Instant.now()) ?: true
}

enum class OrganizationStatus {
    ACTIVE, INACTIVE, SUSPENDED, TRIAL
}

enum class OrganizationType {
    ENTERPRISE, SMB, STARTUP, NON_PROFIT, GOVERNMENT
}

@Embeddable
data class Address(
    val street: String,
    val city: String,
    val state: String? = null,
    val postalCode: String? = null,
    val country: String
)
