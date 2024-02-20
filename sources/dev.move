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

    
    fun init(ctx: &mut sui::tx_context::TxContext) {
        transfer::share_object(
            DevHub {
                id: object::new(ctx),
                owner: tx_context::sender(ctx),
                counter: 0,
                cards: object_table::new(ctx)
            }
        ); 
    }

    public entry fun create_card(
        name: vector<u8>,
        title: vector<u8>,
        img_url: vector<u8>,
        years_of_exp: u8,
        technologies: vector<u8>,
        portfolio: vector<u8>,
        contact: vector<u8>,
        payment: Coin<Sui>,
        devhub: &mut DevHub,
        ctx: &mut TxContext
    ){
        let value = coin::value(&payment);
        assert!(value == MIN_CARD_COST, INSUFFICIENT_FUND);
        transfer::public_transfer(payment, devhub.owner);
        devhub.counter += 1;
        let id = object::new(ctx);

        event::emit(
            CardCreated {
                id: object::uid_to_inner(&id),
                name: string::utf8(name),
                owner: tx_context::sender(ctx),
                title: string::utf8(title),
                contact: string::utf8(contact),
            }
        );

        let devcard = DevCard(
            id: id,
            name: string::utf8(name), 
            owner: address,
            title: string::utf8(title),
            img_url: url::new_unsafe_from_bytes(img_url),
            description: option::none(),
            years_of_exp,
            technologies: string::utf8(technologies),
            portfolio: string::utf8(portfolio),
            contact: string::utf8(contact),
            open_to_work: true
        );

        object_table::add(&mut devhub.cards, devhub.counter, devcard);
    }

    public entry fun update_card_description(devhub: &mut DevHub, new_description: vector<u8>, id: u64, ctx: &mut TxContext){
        let user_card = object_table::borrow_mut(&mut devhub.cards, id);
        assert!(tx_context::sender(ctx) == user_card.owner, NOT_THE_OWNER);
        
        let old_value = option::swap_or_fill(&mut user_card.description, string::utf8(new_description));

        event::emit(
            DescriptionUpdated{
                name: user_card.name,
                owner: user_card.owner,
                new_description: string::utf8(new_description),
            }
        );

        _ = old_value;
    }

    public entry fun deactivate_card(devhub: &mut DevHub, id: u64, ctx: &mut TxContext){
        let user_card = object_table::borrow_mut(&mut devhub.cards, id);
        assert!(tx_context::sender(ctx) == user_card.owner, NOT_THE_OWNER);

        user_card.open_to_work = false;
    }

    public fun getCardInfo(devhub: DevHub, id: u64): (
        String, 
        address,
        String,
        Url,
        Option<String>,
        u8,
        String,
        String,
        String,
        bool,
    ){
        let card =  object_table::borrow(&mut devhub.cards, id);
        (
            card.name, 
            card.owner
            card.title
            card.img_url
            card.description
            card.years_of_exp
            card.technologies
            card.portfolio
            card.contact
            card.open_to_work
        )
    }

}