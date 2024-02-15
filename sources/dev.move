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

    
}