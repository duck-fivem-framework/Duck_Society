Database = {
    maxSocityId = 2,
    maxMemberId = 4,
    maxRoleId = 5,
    maxIdentityId = 5,
    maxPlayerId = 5,
    maxAccountId = 6,
    maxTransactionId = 1,
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
        },
    },
    roles = {
        {
            id = 1,
            societyId = 1,
            name = "officer",
            label = "Officer",
            salary = 5000,
            isDefault = true,
            bankNotification = false,
            canPromote = {
            },
            canDemote = {
            }
        },
        {
            id = 2,
            societyId = 1,
            name = "sergeant",
            label = "Sergeant",
            salary = 7000,
            isDefault = false,
            bankNotification = false,
            canPromote = {
            },
            canDemote = {
            }
        },
        {
            id = 3,
            societyId = 1,
            name = "chief",
            label = "Chief",
            salary = 10000,
            isDefault = false,
            bankNotification = true,
            canPromote = {
            },
            canDemote = {
            }
        },
        {
            id = 4,
            societyId = 2,
            name = "paramedic",
            label = "Paramedic",
            salary = 4500,
            isDefault = true,
            bankNotification = false,
            canPromote = {
            },
            canDemote = {
            }
        },
        {
            id = 5,
            societyId = 2,
            name = "doctor",
            label = "Doctor",
            salary = 8000,
            isDefault = false,
            bankNotification = true,
            canPromote = {
            },
            canDemote = {
            }
        },
    },
    members = {
        {
            id = 1,
            societyId = 1,
            roleId = 1,
            playerId = 1
        },
        {
            id = 3,
            societyId = 1,
            roleId = 2,
            playerId = 3
        },
        {
            id = 2,
            societyId = 2,
            roleId = 4,
            playerId = 2
        },
        {
            id = 4,
            societyId = 2,
            roleId = 5,
            playerId = 4
        },
    },
    identities = {
        {
            id = 1,
            firstname = "john",
            lastname = "doe",
            dateofbirth = "1990-01-01"
        },
        {
            id = 2,
            firstname = "jane",
            lastname = "smith",
            dateofbirth = "1992-02-02"
        },
        {
            id = 3,
            firstname = "mike",
            lastname = "johnson",
            dateofbirth = "1988-03-03"
        },
        {
            id = 4,
            firstname = "emily",
            lastname = "davis",
            dateofbirth = "1995-04-04"
        },
        {
            id = 5,
            firstname = "marc",
            lastname = "hammond",
            dateofbirth = "2000-07-29"
        },
    },
    players = {
        {
            id = 1,
            identityId = 1,
            identifier = "steam:110000000000001",
        },
        {
            id = 2,
            identityId = 2,
            identifier = "steam:110000000000002",
        },
        {
            id = 3,
            identityId = 3,
            identifier = "steam:110000000000003",
        },
        {
            id = 4,
            identityId = 4,
            identifier = "steam:110000000000004",
        },
        {
            id = 5,
            identityId = 5,
            identifier = "steam:110000107b6081d",
            location = {
                x = -1045.78,
                y = -2728.86,
                z = 20.16,
                heading = 25.52
            },
        },
   },
    accounts = {
        {
            id = 1,
            label = "John's Account",
            owner_type = "DuckPlayers",
            owner_id = 1,
            balance = 10000.0,
            usage = "player_bank",
            iban = "AAAA-1234-5678-9012"
        },
        {
            id = 2,
            label = "Jane's Account",
            owner_type = "DuckPlayers",
            owner_id = 2,
            balance = 15000.0,
            usage = "player_bank",
            iban = "BBBB-1234-5678-9012"
        },
        {
            id = 3,
            label = "Police Department Account",
            owner_type = "DuckSociety",
            owner_id = 1,
            balance = 50000.0,
            usage = "society_bank",
            iban = "CCCC-1234-5678-9012"
        },
        {
            id = 4,
            label = "Ambulance Service Account",
            owner_type = "DuckSociety",
            owner_id = 2,
            balance = 30000.0,
            usage = "society_bank",
            iban = "DDDD-1234-5678-9012"
        },
        {
            id = 5,
            label = "Mike's Account",
            owner_type = "DuckPlayers",
            owner_id = 3,
            balance = 20000.0,
            usage = "player_bank",
            iban = "EEEE-1234-5678-9012"
        },
        {
            id = 6,
            label = "Emily's Account",
            owner_type = "DuckPlayers",
            owner_id = 4,
            balance = 25000.0,
            usage = "player_bank",
            iban = "FFFF-1234-5678-9012"
        },
   },
    transactions = {
        {
            id = 1,
            label = "Payment for services",
            owner_type = "DuckAccount",
            owner_id = 4,
            target_type = "DuckAccount",
            target_id = 1,
            balance = 1000.0,
            refunded = false,
            payed_at = nil,
            refunded_at = nil
        },
        {
            id = 2,
            label = "test",
            owner_type = "DuckAccount",
            owner_id = 1,
            target_type = "DuckAccount",
            target_id = 2,
            balance = 100,
            refunded = false,
            payed_at = nil,
            refunded_at = nil
        },
   }
}
