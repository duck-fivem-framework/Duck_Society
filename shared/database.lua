database = {
    maxSocityId = 2,
    maxMemberId = 4,
    maxRoleId = 5,
    maxIdentityId = 4,
    maxPlayerId = 4,
    societies = {
        {
            id = 1,
            name = "police",
            label = "Police Department",
        },
        {
            id = 2,
            name = "ambulance",
            label = "Ambulance Service",
        }
    },
    roles = {
        {
            id = 1,
            societyId = 1,
            name = "officer",
            label = "Officer",
            salary = 5000,
            isDefault = true
        },
        {
            id = 2,
            societyId = 1,
            name = "sergeant",
            label = "Sergeant",
            salary = 7000,
            isDefault = false
        },
        {
            id = 3,
            societyId = 1,
            name = "chief",
            label = "Chief",
            salary = 10000,
            isDefault = false
        },
        {
            id = 4,
            societyId = 2,
            name = "paramedic",
            label = "Paramedic",
            salary = 4500,
            isDefault = true
        },
        {
            id = 5,
            societyId = 2,
            name = "doctor",
            label = "Doctor",
            salary = 8000,
            isDefault = false
        }
    },
    members = {
        {
            id = 1,
            societyId = 1,
            roleId = 1,
            playerId = 1
        },
        {
            id = 2,
            societyId = 2,
            roleId = 4,
            playerId = 2
        },
        {
            id = 3,
            societyId = 1,
            roleId = 2,
            playerId = 3
        },
        {
            id = 4,
            societyId = 2,
            roleId = 5,
            playerId = 4
        }
    },
    identities = {
        {
            id = 1,
            firstname = "John",
            lastname = "Doe",
            dateofbirth = "1990-01-01",
        },
        {
            id = 2,
            firstname = "Jane",
            lastname = "Smith",
            dateofbirth = "1992-02-02",
        },
        {
            id = 3,
            firstname = "Mike",
            lastname = "Johnson",
            dateofbirth = "1988-03-03",
        },
        {
            id = 4,
            firstname = "Emily",
            lastname = "Davis",
            dateofbirth = "1995-04-04",
        }
    },
    players = {
        {
            id = 1,
            identityId = 1,
            identifier = "steam:110000000000001",
            money = 10000,
        },
        {
            id = 2,
            identityId = 2,
            identifier = "steam:110000000000002",
            money = 15000,
        },
        {
            id = 3,
            identityId = 3,
            identifier = "steam:110000000000003",
            money = 20000,
        },
        {
            id = 4,
            identityId = 4,
            identifier = "steam:110000000000004",
            money = 25000,
        }
    }

}