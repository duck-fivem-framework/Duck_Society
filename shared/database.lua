database = {
    maxSocityId = 2,
    maxMemberId = 4,
    maxRoleId = 5,
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
            playerId = 12345
        },
        {
            id = 2,
            societyId = 2,
            roleId = 1,
            playerId = 67890
        },
        {
            id = 3,
            societyId = 1,
            roleId = 2,
            playerId = 54321
        },
        {
            id = 4,
            societyId = 2,
            roleId = 2,
            playerId = 98765
        }
    }

}