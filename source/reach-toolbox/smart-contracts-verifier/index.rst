Smart Contracts Formal Verifier
===============================

Goal
----

The Smart Contracts Formal Verifier can be used to verify that a smart contract
follow the behavior envisionned by its creator. This behavior is expressed
through formal specifications.

Since it exists numerous smart-contract language, we choose to use an existing
framework Why3 used for proving algorithm. The main advantage is to already
benefit from state of the art ways to specify, and prove the correctness of the
program. the compilation to the smart-contract language is usualy done in a
straightforward way.

Examples
--------

We are going to see the proof of a small smart contract which implement
transferable tokens. The code is meant to be compiled to Solidity so some
Solidity features are modelized:

* ``UInt256``: models the uint of solidity and the operations
* ``Default``: models the default value of unintialized values
* ``Adddress``: models the address type
* ``Message``: models the msg object which contains for example the sender
* ``Mapping``: models solidity mapping datastructure
* ``Require``: models the require function which stop the execution if a
  condition is not verified.


   The smart contract method ``transfer`` does the book-keeping of the transfer by
   updating the balance of the sender and the receiver.

.. code-block::

    module T1

       use bool.Bool
       use UInt256
       use Address
       use Message
       use Mapping
       use Require

       type t = {
            balances : mapping address uint256;
       }

       val t:t

       let transfer receiver numTokens =
          t.balances[msg.sender] <- t.balances[msg.sender] - numTokens;
          t.balances[receiver] <- t.balances[receiver] + numTokens

   end

The proof of the function can be attempted in TryWhy3 prefilled with `T1 in
TryWhy3 <http://why3.lri.fr/try/?lang=whyml&code=A4module5UInt256NH1use1int7tA1IntNH2type5uint2567y7x3rangez0y0xffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2F7zNH1let6constantymax%2Buint256%2FB7vfjmHnn4lengthBnnn1256Hnn3radixnnnk7qz1H6function4to%2Bint7nzxkZ7oriipA7mqnNH3clone4export2machRAos6Unsigned2withJQzthh7rHW1maxppeA4maxIntnHnUnsqH2goalyradix%2Bdef%2FrHVVnjjcnH3axiomyzero%2Bunsigned%2Bis%2Bzero%2FrHryto%2Bint%2Bin%2Bbounds%2FrHryextensionality%2FNN1endNNuA5DefaultNKg5defaultPhzaNHkyDefault%2Bbool%2FAp7nnr2bool7oa3falseEKuBuACHj2ZeroAljjArWjjz0NNaNNa5AddressHuM5addressNH1val3equalgYAgAohpzbpAp7IvXK5ensures774resultbkirji79NEUPNHUynon%2Bdefault%2FAd4existszdrAb7tBq7RzQNNSNNS5MessageNHgRHsfNHR1msgZ5privateUML5mutable4senderbbMGXHyinvariant%2FnobboNHudhkBsNHeuaHp1nowoubNNXNNX5MappingNHl1mapT1Map0assHV5mappingB7mzaBszbRVJS2databjhAgBkjBsj7wFVNGdOHugyDefault%2Bmapping%2Fh7nQraihsh7ItAcZk1funsz%2B7PmAk7o7MzofoAi7IoNIur4create7HobbbgslJuePueafTFg1setczmfAfgfsfZmpasqqppsqm2unitL4writescifHbqq7tTauxqbe1oldmpmfcdgDZ7HWYRMojkbAYYkskjmpYsqqppsqmYLYZifHYqqccYYqYeYmpmfcdgNDuX1getjkbYYkskjmpYsqmnncMLcehhrejMGWogniAfhmshgmpfsqmnnLZZUcggjaNDea7HWYodnfceksedmpcsqmnnLcccccgjcNDd1memezidndprdAccqscububdJlVVbkrVefujONNunNNun5RequireNMDyexception%2FyRequireFailed%2F4stringHuF5requireYzsJ4raises77mqAUux1notm7O3oTsAn79Hu7jmqGnI0ifkp2then3raiseOfhUNNWNNW1SumNIuruSOuAHquhHsunpu9HqujHsumNHu11sumczm7vBu3BPzauiYoBbNHul1ModqB4foralljrAjjjjbBmzkzvqBej7yr77u4quuonpll797sr7qu2lnNNHZ2InitZeVu3BqBXXXXUYz0NNvFNNvF0T1NEvLu1T2BoolHqvGHsubHsuaHsvGHsu0NHuhzte77MI6balancesBWWubX7wMD79NHurjmAsNHuz6transfer6receiverynumTokens%2FfKoWf72udquc747Rsmpmmmqmm7sjcHknkkhlinnnnnn7qkNNvLN>`_.
You can click in the tree on Split-and-prove after parsing the code with the ✓ button.

The proof will fail because our modelisation of UInt256 forbid overflow. They
are accepted in solidity (with modulo semantic) but we believe people usually think about the
operations as on mathematical integers. The two failed proof attempts
corresponds to both operations.

Indeed if we only take care of verifying that the sender as enough tokens, as in
the following example (`T2 in
TryWhy3 <http://why3.lri.fr/try/?lang=whyml&code=A4module5UInt256NH1use1int7tA1IntNH2type5uint2567y7x3rangez0y0xffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2F7zNH1let6constantymax%2Buint256%2FB7vfjmHnn4lengthBnnn1256Hnn3radixnnnk7qz1H6function4to%2Bint7nzxkZ7oriipA7mqnNH3clone4export2machRAos6Unsigned2withJQzthh7rHW1maxppeA4maxIntnHnUnsqH2goalyradix%2Bdef%2FrHVVnjjcnH3axiomyzero%2Bunsigned%2Bis%2Bzero%2FrHryto%2Bint%2Bin%2Bbounds%2FrHryextensionality%2FNN1endNNuA5DefaultNK1valf5defaultOgzaNHjyDefault%2Bbool%2FAp7nnr2bool7oZ3falseEKuBuACHj2ZeroAljjArVjjz0NNZNNZ5AddressHuM5addressNHX3equalgYAgAohpzbpAp7IvXK5ensures774resultbkirji79NEUPNHUynon%2Bdefault%2FAd4existszdrAb7tBq7RzQNNSNNS5MessageNHgRHsfNHR1msgZ5privateUML5mutable4senderbbMGXHyinvariant%2FnobboNHudhkBsNHeuaHp1nowoubNNXNNX5MappingNHl1mapT1Map0assHV5mappingB7mzaBszbRVJS2databjhAgBkjBsj7wFVNGdOHugyDefault%2Bmapping%2Fh7nQraihsh7ItAcZk1funsz%2B7PmAk7o7MzofoAi7IoHHur3ghost2init7HoaaafskJueOueZeSNGf4createggghgsgJggggggFg1setazmfAfgfsfXmpYsqqppsqm2unitL4writescifHbqq7tRauxqbe1oldmpmfcdgDZ7HWYRMojkbAYYkskjmpYsqqppsqmYLYZifHYqqccYYqYeYmpmfcdgNDuX1getjkbYYkskjmpYsqmnncMLcehhrejMGWogniAfhmshgmpfsqmnnLZZUcggjaNDea7HWYodnfceksedmpcsqmnnLcccccgjcNDd1memezidndprdAccqscububdJlVVbkrVefujONNunNNun5RequireNMDyexception%2FyRequireFailed%2F4stringHuF5requireYzsJ4raises77mqAUux1notm7O3oTsAn79Hu9jmqGnI0ifkp2then3raiseOfhUNNWNNW1SumNIuruSOuAHquhHsunpu%2FHqujHsumNHu31sumczm7vBu5BPzauiYoBbNHul1ModqB4foralljrAjjjjbBmzkzvqBej7yr77u6quwonpll797sr7qu4lnNNHZ2InitZeVu5BqBXXXXUYz0NNvHNNvH0T2NEvNu3T2BoolHqvOqvHHqvHHsubHsuaHsvHHsu2NHuhztc77MI6balancesBUUubV7wMD79NHutjmAsNHu16transfer6receiverynumTokens%2FJu2fu9z%2Bu2kSb72udquc747xgaFVKuzA7np7Rygjgggqg7Yo7h1Not4enough3token1for4source7BwHgjgggqgY7Rsmpmmmqmm7sb7wHknkkPlinnnnnn7qkNNvHN>`_

One verification condition is still not proved, it corresponds to the case where
the receiver as too many tokens to accept them.


.. code-block::

   module T2

       use bool.Bool
       use int.Int
       use UInt256
       use Address
       use Message
       use Mapping
       use Require

       type t = {
            balances : mapping address uint256;
       }

       val t:t

       let transfer receiver numTokens
         raises { RequireFailed _ -> t.balances[msg.sender] < numTokens }
       =
          require(numTokens <= t.balances[msg.sender]) "Not enough token for source";
          t.balances[msg.sender] <- t.balances[msg.sender] - numTokens;
          t.balances[receiver] <- t.balances[receiver] + numTokens

   end

The ``raises { RequireFailed _ -> t.balances[msg.sender] < numTokens }``
allows to precisely know all the cases where the smart-contract will fail. When
smart-contract use multiple sub-function call it can start to be tricky to know
the precise condition of application.

Now when checking both cases the method is proved free of problematic behavior
during execution (`T3 in TryWhy3 <http://why3.lri.fr/try/?lang=whyml&code=A4module5UInt256NH1use1int7tA1IntNH2type5uint2567y7x3rangez0y0xffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2F7zNH1let6constantymax%2Buint256%2FB7vfjmHnn4lengthBnnn1256Hnn3radixnnnk7qz1H6function4to%2Bint7nzxkZ7oriipA7mqnNH3clone4export2machRAos6Unsigned2withJQzthh7rHW1maxppeA4maxIntnHnUnsqH2goalyradix%2Bdef%2FrHVVnjjcnH3axiomyzero%2Bunsigned%2Bis%2Bzero%2FrHryto%2Bint%2Bin%2Bbounds%2FrHryextensionality%2FNN1endNNuA5DefaultNK1valf5defaultOgzaNHjyDefault%2Bbool%2FAp7nnr2bool7oZ3falseEKuBuACHj2ZeroAljjArVjjz0NNZNNZ5AddressHuM5addressNHX3equalgYAgAohpzbpAp7IvXK5ensures774resultbkirji79NEUPNHUynon%2Bdefault%2FAd4existszdrAb7tBq7RzQNNSNNS5MessageNHgRHsfNHR1msgZ5privateUML5mutable4senderbbMGXHyinvariant%2FnobboNHudhkBsNHeuaHp1nowoubNNXNNX5MappingNHl1mapT1Map0assHV5mappingB7mzaBszbRVJS2databjhAgBkjBsj7wFVNGdOHugyDefault%2Bmapping%2Fh7nQraihsh7ItAcZk1funsz%2B7PmAk7o7MzofoAi7IoHHur3ghost2init7HoaaafskJueOueZeSNGf4createggghgsgJggggggFg1setazmfAfgfsfXmpYsqqppsqm2unitL4writescifHbqq7tRauxqbe1oldmpmfcdgDZ7HWYRMojkbAYYkskjmpYsqqppsqmYLYZifHYqqccYYqYeYmpmfcdgNDuX1getjkbYYkskjmpYsqmnncMLcehhrejMGWogniAfhmshgmpfsqmnnLZZUcggjaNDea7HWYodnfceksedmpcsqmnnLcccccgjcNDd1memezidndprdAccqscububdJlVVbkrVefujONNunNNun5RequireNMDyexception%2FyRequireFailed%2F4stringHuF5requireYzsJ4raises77mqAUux1notm7O3oTsAn79Hu9jmqGnI0ifkp2then3raiseOfhUNNWNNW1SumNIuruSOuAHquhHsunpu%2FHqujHsumNHu31sumczm7vBu5BPzauiYoBbNHul1ModqB4foralljrAjjjjbBmzkzvqBej7yr77u6quwonpll797sr7qu4lnNNHZ2InitZeVu5BqBXXXXUYz0NNvHNNvH0T3NEvNu3T2BoolHqvOqvHHqvHHsubHsuaHsvHHsu2NHuhztc77MI6balancesBUUubV7wMD79NHutjmAsNHu1vDyuint256%2Bmax%2FplgMLy0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff%2FNMDn6transfer6receiverynumTokens%2FJu2bu9z%2Bu2ePX72udquc747xg7XuMhXqjmjjdk7qjTMGXHuzA7np7Ryhhhhcqc7Yo7h1Not4enough3token1for4source7BwHcAceheeXXbV7sY7oaA1Too2manyaaydestination%2FaHccccUqUb7Rsmpmmmqmmcc7wHknkkYlinnnnnnPkNNvGN>`_)

.. code-block::

   module T3

       use bool.Bool
       use int.Int
       use UInt256
       use Address
       use Message
       use Mapping
       use Require

       type t = {
            balances : mapping address uint256;
       }

       val t:t

       let function uint256_max: uint256 =
               0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff

       let transfer receiver numTokens
         raises { RequireFailed _ -> t.balances[msg.sender] < numTokens \/
                                     uint256_max < t.balances[receiver] + numTokens }
          =
          require(numTokens <= t.balances[msg.sender]) "Not enough token for source";
          require(t.balances[receiver] <= uint256_max - numTokens) "Too many token for destination";
          t.balances[msg.sender] <- t.balances[msg.sender] - numTokens;
          t.balances[receiver] <- t.balances[receiver] + numTokens

   end

We are now sure that the smart-contract doesn't have arithmetic traps but we are
not convinced that the bookkeeping is correctly done. So we are going to prove
that the total number of token is constant along the life of the contract. For
that we use an invariant ``sum balances = initial``, with initial used only for
the proof ``ghost`` it will be removed when extracted to solidity( `T4 in
Trywhy3 <http://why3.lri.fr/try/?lang=whyml&code=A4module5UInt256NH1use1int7tA1IntNH2type5uint2567y7x3rangez0y0xffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2Bffff%2F7zNH1let6constantymax%2Buint256%2FB7vfjmHnn4lengthBnnn1256Hnn3radixnnnk7qz1H6function4to%2Bint7nzxkZ7oriipA7mqnNH3clone4export2machRAos6Unsigned2withJQzthh7rHW1maxppeA4maxIntnHnUnsqH2goalyradix%2Bdef%2FrHVVnjjcnH3axiomyzero%2Bunsigned%2Bis%2Bzero%2FrHryto%2Bint%2Bin%2Bbounds%2FrHryextensionality%2FNN1endNNuA5DefaultNK1valf5defaultOgzaNHjyDefault%2Bbool%2FAp7nnr2bool7oZ3falseEKuBuACHj2ZeroAljjArVjjz0NNZNNZ5AddressHuM5addressNHX3equalgYAgAohpzbpAp7IvXK5ensures774resultbkirji79NEUPNHUynon%2Bdefault%2FAd4existszdrAb7tBq7RzQNNSNNS5MessageNHgRHsfNHR1msgZ5privateUML5mutable4senderbbMGXHyinvariant%2FnobboNHudhkBsNHeuaHp1nowoubNNXNNX5MappingNHl1mapT1Map0assHV5mappingB7mzaBszbRVJS2databjhAgBkjBsj7wFVNGdOHugyDefault%2Bmapping%2Fh7nQraihsh7ItAcZk1funsz%2B7PmAk7o7MzofoAi7IoHHur3ghost2init7HoaaafskJueOueZeSNGf4createggghgsgJggggggFg1setazmfAfgfsfXmpYsqqppsqm2unitL4writescifHbqq7tRauxqbe1oldmpmfcdgDZ7HWYRMojkbAYYkskjmpYsqqppsqmYLYZifHYqqccYYqYeYmpmfcdgNDuX1getjkbYYkskjmpYsqmnncMLcehhrejMGWogniAfhmshgmpfsqmnnLZZUcggjaNDea7HWYodnfceksedmpcsqmnnLcccccgjcNDd1memezidndprdAccqscububdJlVVbkrVefujONNunNNun5RequireNMDyexception%2FyRequireFailed%2F4stringHuF5requireYzsJ4raises77mqAUux1notm7O3oTsAn79Hu9jmqGnI0ifkp2then3raiseOfhUNNWNNW1SumNIuruSOuAHquhHsunpu%2FHqujHsumNHu31sumczm7vBu5BPzauiYoBbNHul1ModqB4foralljrAjjjjbBmzkzvqBej7yr77u6quwonpll797sr7qu4lnNNHZ2InitZeVu5BqBXXXXUYz0NNvHNNNvH0T4NEvNu3T2BoolHqvOqvHHqvHHsubHsuaHsvIHsvHHsu2HsvDNHuhzta77MI6balancesBSSubT7wHul5initialBnXpMD79HubivJhgknH0bynJqpz0kHmquk7HIwFkNHuqaeAsNHuyu%2Byuint256%2Bmax%2FApZjMLy0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff%2FNMDn6transfer6receiverynumTokens%2FKuzZu6z%2Buze7tY72ucqub747xg7XuMiXqjmjjdk7qjTMGXHuwA7np7Ryhhhhcqc7Yo7h1Not4enough3token1for4source7BwHcAceheeXXbV7sY7oaA1Too2manyaaydestination%2FaHccccUqUb7Rsmpmmmqmmcc7wHknkkYlinnnnnnPkNNvAN>`_

.. code-block::

   module T4

       use bool.Bool
       use int.Int
       use UInt256
       use Address
       use Message
       use Default
       use Mapping
       use Require
       use Sum

       type t = {
            balances : mapping address uint256;
            ghost initial : int;
       }
       invariant { sum balances = initial }
       by {
         initial = 0;
         balances = init ();
       }

       val t:t

       let function uint256_max: uint256 =
               0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff

       let transfer receiver numTokens
          raises { RequireFailed _ -> t.balances[msg.sender] < numTokens \/
                                      uint256_max < t.balances[receiver] + numTokens }
          =
          require(numTokens <= t.balances[msg.sender]) "Not enough token for source";
          require(t.balances[receiver] <= uint256_max - numTokens) "Too many token for destination";
          t.balances[msg.sender] <- t.balances[msg.sender] - numTokens;
          t.balances[receiver] <- t.balances[receiver] + numTokens

   end


Links
-----
