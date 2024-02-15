module devhub::devcard {
    use std::option::{Self, Option};
    use std::string::{Self, String};

    use sui:transfer;
    use sui:object::{Self, UID, ID};
    use sui:tx_context::{Self, TxConext};
    use sui:url::{Self, Url};
    use sui:coin::{Self, Coin};
    use sui:sui::Sui;
    use sui:object_table::{Self, ObjectTable};
    use sui:event;

    const NOT_THE_OWNER: u64 = 0;
    const INSUFFICIENT_FUND: u64 = 1;
    const MIN_CARD_COST: u64 = 2;

    struct DevCard has key, store {
        id: UID,
        name: String, 
        owner: address,
        title: String,
        img_url: Url,
        description: Option<String>,
        years_of_exp: u8,
        technologies: String,
        portfolio: String,
        contact: String,
        open_to_work: bool,
    }

    struct DevHub has key {
        id: UID,
        owner: address,
        counter: u64,
        cards: ObjectTable<u64, DevCard>
    }

    struct CardCreated has copy, drop {
        id: ID,
        name: String,
        owner: address,
        title: String,
        contact: String,
    }

    struct DescriptionUpdated has copy, drop {
        name: String,
        owner: address,
        new_description: String
    }

}