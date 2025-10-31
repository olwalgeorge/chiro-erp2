package com.chiro.erp.platform.identity.interfaces.rest

import com.chiro.erp.platform.identity.domain.ports.inbound.UserManagementUseCase
import com.chiro.erp.platform.identity.domain.ports.inbound.CreateUserCommand
import com.chiro.erp.platform.identity.domain.ports.inbound.UpdateUserCommand
import jakarta.inject.Inject
import jakarta.ws.rs.*
import jakarta.ws.rs.core.MediaType
import jakarta.ws.rs.core.Response
import java.util.*

/**
 * REST controller for user management operations
 */
@Path("/api/v1/users")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
class UserController @Inject constructor(
    private val userManagementUseCase: UserManagementUseCase
) {

    @POST
    suspend fun createUser(request: CreateUserRequest): Response {
        val command = CreateUserCommand(
            username = request.username,
            email = request.email,
            password = request.password,
            firstName = request.firstName,
            lastName = request.lastName,
            tenantId = request.tenantId,
            roleIds = request.roleIds
        )
        
        val user = userManagementUseCase.createUser(command)
        return Response.status(Response.Status.CREATED)
            .entity(UserResponse.from(user))
            .build()
    }

    @GET
    @Path("/{userId}")
    suspend fun getUser(@PathParam("userId") userId: UUID): Response {
        val user = userManagementUseCase.getUserById(userId)
            ?: return Response.status(Response.Status.NOT_FOUND).build()
        
        return Response.ok(UserResponse.from(user)).build()
    }

    @PUT
    @Path("/{userId}")
    suspend fun updateUser(
        @PathParam("userId") userId: UUID,
        request: UpdateUserRequest
    ): Response {
        val command = UpdateUserCommand(
            firstName = request.firstName,
            lastName = request.lastName,
            email = request.email,
            roleIds = request.roleIds
        )
        
        val user = userManagementUseCase.updateUser(userId, command)
        return Response.ok(UserResponse.from(user)).build()
    }

    @DELETE
    @Path("/{userId}")
    suspend fun deleteUser(@PathParam("userId") userId: UUID): Response {
        userManagementUseCase.deleteUser(userId)
        return Response.noContent().build()
    }

    @GET
    suspend fun getUsers(
        @QueryParam("tenantId") tenantId: UUID,
        @QueryParam("page") @DefaultValue("0") page: Int,
        @QueryParam("size") @DefaultValue("20") size: Int
    ): Response {
        val users = userManagementUseCase.getAllUsers(tenantId, page, size)
        val response = users.map { UserResponse.from(it) }
        return Response.ok(response).build()
    }
}
