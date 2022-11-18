{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TypeApplications #-}

module Main where

import OpenGames
import OpenGames.Preprocessor
import OpenGames.Preprocessor.CompileBlock
import Graphics as Gfx

import Data.GraphViz
import Data.GraphViz.Attributes.Complete
import Data.GraphViz.Commands.IO


customParams :: GraphvizParams n String Gfx.ArrowType () String
customParams = let rec = quickParams :: GraphvizParams n String Gfx.ArrowType () String in
                   rec { fmtNode = \x -> Shape BoxShape : (fmtNode rec x)
                       , fmtEdge = \case (_, _, (Contravariant lbl)) -> [Label $ toLabelValue lbl, Style [SItem Dotted []]]
                                         (_, _, Covariant lbl) -> [Label $ toLabelValue lbl, Style [SItem Solid []]]
                                         (_, _, Gfx.Both lbl) -> [Label $ toLabelValue lbl, Style [SItem Dotted [], SItem Solid []]] }

bidding = [parseTree|

   inputs    :      ;
   feedback  :      ;

   :-----------------:

   label : AliceDraw ;
   inputs    :      ;
   feedback  :      ;
   operation : natureDrawsTypeStage "Alice" ;
   outputs   :  aliceValue ;
   returns   :      ;

   label : BobDraw ;
   inputs    :      ;
   feedback  :      ;
   operation : natureDrawsTypeStage "Bob" ;
   outputs   :  bobValue ;
   returns   :      ;

   label : CarolDraw ;
   inputs    :      ;
   feedback  :      ;
   operation : natureDrawsTypeStage "Carol" ;
   outputs   :  carolValue ;
   returns   :      ;

   label : AliceBid ;
   inputs    :  aliceValue    ;
   feedback  :      ;
   operation :  biddingStage "Alice" ;
   outputs   :  aliceDec ;
   returns   :  payments  ;

   label : BobBid ;
   inputs    :  bobValue    ;
   feedback  :      ;
   operation :  biddingStage "Bob" ;
   outputs   :  bobDec ;
   returns   :  payments  ;

   label : CarolBid ;
   inputs    :  carolValue    ;
   feedback  :      ;
   operation :  biddingStage "Carol" ;
   outputs   :  carolDec ;
   returns   :  payments  ;

   label : Auction ;
   inputs    :  [("Alice",aliceDec),("Bob",bobDec),("Carol",carolDec)]  ;
   feedback  :      ;
   operation :   transformPayments kPrice kSlots noLotteries paymentFunction ;
   outputs   :  payments ;
   returns   :      ;
   :-----------------:

   outputs   :      ;
   returns   :      ;
   |]

prisonersDilemmaVerbose = [parseTree|

   inputs    :      ;
   feedback  :      ;

   :----------------------------:
   inputs    :      ;
   feedback  :      ;
   operation : dependentDecision "player1" (const [Cooperate,Defect]);
   outputs   : decisionPlayer1 ;
   returns   : prisonersDilemmaMatrix decisionPlayer1 decisionPlayer2 ;

   inputs    :      ;
   feedback  :      ;
   operation : dependentDecision "player2" (const [Cooperate,Defect]);
   outputs   : decisionPlayer2 ;
   returns   : prisonersDilemmaMatrix decisionPlayer2 decisionPlayer1 ;

   :----------------------------:

   outputs   :      ;
   returns   :      ;
  |]

main :: IO ()
main = writeDotFile "dotfile" (graphToDot customParams (convertBlock prisonersDilemmaVerbose))
